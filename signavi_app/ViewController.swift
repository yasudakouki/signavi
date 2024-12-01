import UIKit
import AVFoundation
import Vision
import Foundation

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate,AVCapturePhotoCaptureDelegate {
    
    //画面に表示するラベル用
    @IBOutlet weak var estimate_cals_time: UILabel!
    
    //時間の計測を確認するため
    var now: Date!
    var after_calc_time = 0
    var before_calc_time = 0
    var calc_time = 0
    //音を流す用に追加
    let musicplayer = SoundPlayer()
    //画面FPSの設定用に追加
    var desiredFrameRate = 30
    
    var captureSession = AVCaptureSession()
    var previewView = UIImageView()
    var previewLayer:AVCaptureVideoPreviewLayer!
    var videoOutput:AVCaptureVideoDataOutput!
    var miss_frameCounter = 0
    var frameInterval = 1
    var videoSize = CGSize.zero
    let colors:[UIColor] = {
        var colorSet:[UIColor] = []
        for _ in 0...80 {
            let color = UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1)
            colorSet.append(color)
        }
        return colorSet
    }()
    let ciContext = CIContext()
    var classes:[String] = []
    
    lazy var yoloRequest:VNCoreMLRequest! = {
        do {
            let model = try best_640().model
            guard let classes = model.modelDescription.classLabels as? [String] else {
                fatalError()
            }
            self.classes = classes
            let vnModel = try VNCoreMLModel(for: model)
            let request = VNCoreMLRequest(model: vnModel)
            return request
        } catch let error {
            fatalError("mlmodel error.")
        }
    }()
    
    override func viewDidLoad() {
        //時間計測用にカメラを準備するタイミングで時間の構造体も準備
        now = Date()
        super.viewDidLoad()
        setupVideo()
    }


    func setupVideo(){
        previewView.frame = view.bounds
        view.addSubview(previewView)

        //ミスカウントのためのラベル設定（配置など)
        estimate_cals_time.frame = CGRect(x: 20, y: 40, width: 600, height: 60)
        estimate_cals_time.text="label set complete"
        
        
        view.addSubview(estimate_cals_time)
        // ラベルを前面に移動 これなしだとカメラ映像の下になる
        view.bringSubviewToFront(estimate_cals_time)
        
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else {
            print("Error: No video devices available")
            return
        }
        
        
        let deviceInput = try! AVCaptureDeviceInput(device: device)
        
        captureSession.beginConfiguration()


        captureSession.addInput(deviceInput)
        videoOutput = AVCaptureVideoDataOutput()

        let queue = DispatchQueue(label: "VideoQueue")
        videoOutput.setSampleBufferDelegate(self, queue: queue)
        captureSession.addOutput(videoOutput)
        if let videoConnection = videoOutput.connection(with: .video) {
            if videoConnection.isVideoOrientationSupported {
                videoConnection.videoOrientation = .portrait
            }
        }
        captureSession.commitConfiguration()

        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
        }
        
        
        // フレームレート設定  絶対最後にいれろ 絶対だぞ絶対
        // ↑カメラとの接続などがない状態で設定しても意味ない的な感じかも
        do {
            
            try device.lockForConfiguration()

            // フレームレートの設定
            device.activeVideoMinFrameDuration = CMTimeMake( value: 1, timescale: Int32(desiredFrameRate)  )
            device.activeVideoMaxFrameDuration = CMTimeMake( value: 1, timescale: Int32(desiredFrameRate)  )

            // 設定後、ロック解除
            device.unlockForConfiguration()
            print("Frame rate configured")
        } catch {
            // エラーハンドリング：ロック失敗時
            print("Error locking configuration: \(error)")
            return
        }
        
    }
    
    func detection(pixelBuffer: CVPixelBuffer) -> UIImage? {
        do {
            let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer)
            try handler.perform([yoloRequest])
            guard let results = yoloRequest.results as? [VNRecognizedObjectObservation] else {
                return nil
            }
            var detections:[Detection] = []
            for result in results {
                let flippedBox = CGRect(x: result.boundingBox.minX, y: 1 - result.boundingBox.maxY, width: result.boundingBox.width, height: result.boundingBox.height)
                let box = VNImageRectForNormalizedRect(flippedBox, Int(videoSize.width), Int(videoSize.height))

                guard let label = result.labels.first?.identifier as? String,
                        let colorIndex = classes.firstIndex(of: label) else {
                        return nil
                }
                let detection = Detection(box: box, confidence: result.confidence, label: label, color: colors[colorIndex])
                detections.append(detection)
            }
            let drawImage = drawRectsOnImage(detections, pixelBuffer)
            return drawImage
        } catch let error {
            print(error)
            return nil
        }
    }
    
    func drawRectsOnImage(_ detections: [Detection], _ pixelBuffer: CVPixelBuffer) -> UIImage? {
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let cgImage = ciContext.createCGImage(ciImage, from: ciImage.extent)!
        let size = ciImage.extent.size
        guard let cgContext = CGContext(data: nil,
                                        width: Int(size.width),
                                        height: Int(size.height),
                                        bitsPerComponent: 8,
                                        bytesPerRow: 4 * Int(size.width),
                                        space: CGColorSpaceCreateDeviceRGB(),
                                        bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else { return nil }
        cgContext.draw(cgImage, in: CGRect(origin: .zero, size: size))
        for detection in detections {
            let invertedBox = CGRect(x: detection.box.minX, y: size.height - detection.box.maxY, width: detection.box.width, height: detection.box.height)
            if let labelText = detection.label {
                cgContext.textMatrix = .identity
                
                let text = "\(labelText) : \(round(detection.confidence*100))"
                
                let textRect  = CGRect(x: invertedBox.minX + size.width * 0.01, y: invertedBox.minY - size.width * 0.01, width: invertedBox.width, height: invertedBox.height)
                let textStyle = NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
                
                let textFontAttributes = [
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: textRect.width * 0.1, weight: .bold),
                    NSAttributedString.Key.foregroundColor: detection.color,
                    NSAttributedString.Key.paragraphStyle: textStyle
                ]
                
                cgContext.saveGState()
                defer { cgContext.restoreGState() }
                let astr = NSAttributedString(string: text, attributes: textFontAttributes)
                let setter = CTFramesetterCreateWithAttributedString(astr)
                let path = CGPath(rect: textRect, transform: nil)
                
                let frame = CTFramesetterCreateFrame(setter, CFRange(), path, nil)
                cgContext.textMatrix = CGAffineTransform.identity
                CTFrameDraw(frame, cgContext)
                
                cgContext.setStrokeColor(detection.color.cgColor)
                cgContext.setLineWidth(9)
                cgContext.stroke(invertedBox)
            }
        }
        
        guard let newImage = cgContext.makeImage() else { return nil }
        return UIImage(ciImage: CIImage(cgImage: newImage))
    }

    
    //from connecitonによりカメラからフレームくるたびに実行される
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection)
    {
        //演算時間の計算に使用
        before_calc_time = Int(Date().timeIntervalSince(now) * 1000)
        
        
        if videoSize == CGSize.zero {
            guard let width = sampleBuffer.formatDescription?.dimensions.width,
                  let height = sampleBuffer.formatDescription?.dimensions.height else {
                fatalError()
            }
            videoSize = CGSize(width: CGFloat(width), height: CGFloat(height))
        }
        
        //if frameintervalによる設定はいらないかも、 if抜きで下に設定している
        //一応 /* */ で残してる
        /*
        if frameCounter == frameInterval {
            frameCounter = 0
            guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
            guard let drawImage = detection(pixelBuffer: pixelBuffer) else {
                return
            }
            DispatchQueue.main.async {
                self.previewView.image = drawImage
            }
        }
        */
        
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        guard let drawImage = detection(pixelBuffer: pixelBuffer) else {
            return
        }
        

        //推定時間を計算してラベルに反映
        after_calc_time = Int(Date().timeIntervalSince(now) * 1000)
        
        calc_time = after_calc_time - before_calc_time

        
        DispatchQueue.main.async {
            self.previewView.image = drawImage
                       
            
            self.estimate_cals_time.text = "estimate calc time: " + String(self.calc_time) + "ms"
        }
        
        

    }
}

struct Detection {
    let box:CGRect
    let confidence:Float
    let label:String?
    let color:UIColor
}
