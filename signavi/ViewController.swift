import UIKit
import AVFoundation

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    @IBOutlet weak var estimate_cals_time: UILabel! // ラベル
    @IBOutlet weak var setting_button: TapAreaExpandableButton! //UIButton!  //画面遷移用のボタン

    //設定画面にある 描写on/offの変数(bool)

    var previewView = UIImageView() // カメラ映像表示用ビュー
    var cameraManager = CameraManager() // CameraManagerを利用
    
    var soundPlayer = SoundPlayer()//音声アナウンスを利用するため
    
    var videoSize = CGSize.zero
    
    //時間の計測を確認するため
    var now: Date!
    var after_calc_time = 0
    var before_calc_time = 0
    var calc_time = 0
    var detect_signs: Set<String> = []
    var frame_count = 0
    
    var renderManager = RenderManager() //描写用
    //モデルの読み込みのinitや検知のdetectionを呼び出す
    private var detectionManager: DetectionManager!
    
    var desiredFrameRate = 20 // フレームレート設定
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Setting up camera...")
        now = Date()
        
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
        
        // スリープを防止
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
        // ナビゲーションバーを非表示にする
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        let max_width: CGFloat = view.bounds.width
        // ボタンのレイアウトを更新
        setting_button.frame = CGRect(
            x: max_width - 50 - 20 ,  // 右端から50px（ボタンの幅）と余白20pxを引いた位置
            y: 40,  // 上から40pxの位置
            width: 50,  // ボタンの幅
            height: 50  // ボタンの高さ
        )
            
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
        view.bringSubviewToFront(setting_button)
        view.bringSubviewToFront(estimate_cals_time)
    }
    
    // AVCaptureVideoDataOutputSampleBufferDelegateのメソッド
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        //演算時間の計算に使用
        before_calc_time = Int(Date().timeIntervalSince(now) * 1000)
        
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
        
        //発見した標識のラベルを追加する set型だから同じやつは追加されない
        for detection in detections {
            if let label = detection.label {
                detect_signs.insert(label) // アンラップ後に追加
            }
        }
        
        frame_count = frame_count + 1
        
        //数百フレームごとに音声アナウンスしたい
        if frame_count >= 200 {
            print("frame_countをリセットします")
            frame_count = 0
            //標識がある場合にて再生(emptyじゃない場合のみ)
            if !detect_signs.isEmpty {
                print("音を再生します")
                //音の再生について
                //soundPlayer.musicPlayer(Detection_label: "この変数は今は使わない")
                //検出した標識をリセットする
                detect_signs=[]
            }
        }
        
        //設定画面にある 描写on/offの変数(bool)
        let drawRectangle_TF = UserDefaults.standard.object(forKey: "draw_rectangle") as? Bool ?? false
        
        DispatchQueue.main.async {
            if drawRectangle_TF {
                // 描画がONの場合、検出結果を描画する
                self.previewView.image = self.renderManager.render(
                    detections: detections,
                    pixelBuffer: pixelBuffer,
                    onView: self.view,
                    videoSize: self.videoSize,
                    RectVisible: drawRectangle_TF
                )
            } else {
                // 描画がOFFの場合、単純にカメラ映像を表示する
                let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
                let uiImage = UIImage(ciImage: ciImage)
                self.previewView.image = uiImage
            }
            
            self.after_calc_time = Int(Date().timeIntervalSince(self.now) * 1000)
            self.calc_time = self.after_calc_time - self.before_calc_time
            self.estimate_cals_time.text="estimate:\(self.calc_time)ms"
            print("estimate:\(self.calc_time)")
        }
    }
}
