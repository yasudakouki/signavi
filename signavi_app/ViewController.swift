import UIKit
import AVFoundation

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    @IBOutlet weak var estimate_cals_time: UILabel! // ラベル
    var previewView = UIImageView() // カメラ映像表示用ビュー
    var cameraManager = CameraManager() // CameraManagerを利用
    
    var videoSize = CGSize.zero
    
    var renderManager = RenderManager() //描写用
    //モデルの読み込みのinitや検知のdetectionを呼び出す
    private var detectionManager: DetectionManager!
    
    var desiredFrameRate = 30 // フレームレート設定
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Setting up camera...")
        
        
        
        
        let screenSize = UIScreen.main.bounds.size
        
        // DetectionManagerの初期化
        detectionManager = DetectionManager(videoSize: screenSize)

        
        // カメラのセットアップ
        if let previewLayer = cameraManager.setupCamera(previewView: previewView, delegate: self, desiredFrameRate: desiredFrameRate) {
            // プレビュー表示用レイヤーをビューに追加
            previewLayer.frame = view.bounds
            view.layer.addSublayer(previewLayer)
        } else {
            print("Failed to set up camera.")
        }
        
        
        // UIセットアップ
        setupUI()
        
        
        
    }
    
    func setupUI() {
        // プレビュー表示用ビューを設定
        previewView.frame = view.bounds
        view.addSubview(previewView)
        
        // ラベルの位置とサイズを設定
        estimate_cals_time.frame = CGRect(x: 20, y: 40, width: 300, height: 60)
        estimate_cals_time.text = "Label set complete"
        view.addSubview(estimate_cals_time)
        
        // ラベルを前面に表示
        view.bringSubviewToFront(estimate_cals_time)
    }
    
    // AVCaptureVideoDataOutputSampleBufferDelegateのメソッド
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        
        if videoSize == CGSize.zero {
            guard let width = sampleBuffer.formatDescription?.dimensions.width,
                  let height = sampleBuffer.formatDescription?.dimensions.height else {
                fatalError()
            }
            videoSize = CGSize(width: CGFloat(width), height: CGFloat(height))
        }
        
        
        
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        
        print("Frame get")
        // 物体検出を実行
        let detections = detectionManager.detectObjects(pixelBuffer: pixelBuffer, videoSize: videoSize)
         
        // 検出結果をコンソールに表示
        for detection in detections {
            print("Detected object: \(detection.label ?? "Unknown")")
            print("Bounding Box: \(detection.box)")
            print("Confidence: \(detection.confidence)")
        }
        
        
        DispatchQueue.main.async {
            
            self.previewView.image=self.renderManager.render(detections: detections, pixelBuffer: pixelBuffer, onView: self.view,videoSize: self.videoSize)
            
        }
         

        
        
        
        
    }
    
}
