import UIKit
import AVFoundation

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    @IBOutlet weak var estimate_cals_time: UILabel! // ラベル
    @IBOutlet weak var setting_button: TapAreaExpandableButton! //UIButton!  //画面遷移用のボタン

    //設定画面にある 描写on/offの変数(bool)

    var previewView = UIImageView() // カメラ映像表示用ビュー
    var cameraManager = CameraManager() // CameraManagerを利用
    
    // AppDelegateのsoundPlayerインスタンスを参照するためのプロパティ
    var soundPlayer: SoundPlayer {
        var player: SoundPlayer!
        DispatchQueue.main.sync {
            player = (UIApplication.shared.delegate as! AppDelegate).soundPlayer
        }
        return player
    }
    
    var videoSize = CGSize.zero
    
    //時間の計測を確認するため
    var now: Date!
    var after_calc_time = 0
    var before_calc_time = 0
    var calc_time = 0
    var detect_signs: Set<String> = []
    var frame_count = 0
    var viewdidappear_bool = false
    
    var renderManager = RenderManager() //描写用
    //モデルの読み込みのinitや検知のdetectionを呼び出す
    private var detectionManager: DetectionManager!
    
    var desiredFrameRate = 20 // フレームレート設定
    
    
    //アプリでのカメラ等の初期設定用 １回のみ実行
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
    
    
    
    //画面遷移時(設定から戻ってきて実行する)　1回目はskipする
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        if viewdidappear_bool {
            // 初回起動時には何も実行しない
            print("viewDidAppear: 2回目以降")
        } else {
            // 2回目以降の表示時に実行する処理
            print("viewDidAppear: 初回起動時")
            viewdidappear_bool = true
            return
        }
        
        
        guard let device = AVCaptureDevice.default(for: .video) else {
            print("Error: No video devices available")
            return
        }
        
        if UserDefaults.standard.object(forKey: "setting_fps_rate") == nil {
            UserDefaults.standard.set(true, forKey: "setting_fps_rate")
        }
        
        let setting_fps_rate : Int = UserDefaults.standard.object(forKey: "setting_fps_rate") as? Int ?? 20
        
        do {
            try device.lockForConfiguration()
            device.activeVideoMinFrameDuration = CMTime(value: 1, timescale: Int32(setting_fps_rate) )
            device.activeVideoMaxFrameDuration = CMTime(value: 1, timescale: Int32(setting_fps_rate) )
            device.unlockForConfiguration()
        } catch {
            print("Failed to lock device for configuration: \(error.localizedDescription)")
        }
        
    }
    
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
        // ナビゲーションバーを非表示にする
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        
        
        /*
        let max_width: CGFloat = view.bounds.width
        
        
        // ボタンのレイアウトを更新
        setting_button.frame = CGRect(
            x: max_width - 50 - 20 ,  // 右端から50px（ボタンの幅）と余白20pxを引いた位置
            y: 40,  // 上から40pxの位置
            width: 50,  // ボタンの幅
            height: 50  // ボタンの高さ
        )
         */
            
    }
    
    func setupUI() {
        // プレビュー表示用ビューを設定
        previewView.frame = view.bounds
        view.addSubview(previewView)
        
        // ラベルの位置とサイズを設定
        let estimate_label_Width = (UIScreen.main.bounds.width)/2
        estimate_cals_time.frame = CGRect(x: 20, y: 40, width: estimate_label_Width, height: 60)
        estimate_cals_time.text = "Label set complete"
        view.addSubview(estimate_cals_time)
        
        
        if let originalImage = UIImage(named: "haguruma") {
            let newSize = CGSize(width: 100, height: 100) // 必要な大きさに指定
            UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
            originalImage.draw(in: CGRect(origin: .zero, size: newSize))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            setting_button.setImage(resizedImage, for: .normal)
        }


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
                soundPlayer.musicPlayer(Detection_label: label)
            }
        }
        
        frame_count = frame_count + 1
        
        
        //設定画面にある 描写on/offの変数(bool)の読み込み
        if UserDefaults.standard.object(forKey: "draw_rectangle") == nil {
            UserDefaults.standard.set(true, forKey: "draw_rectangle")
        }
        
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
