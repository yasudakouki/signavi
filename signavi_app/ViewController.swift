import UIKit
import AVFoundation

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate,AVCapturePhotoCaptureDelegate {
    @IBOutlet weak var estimate_cals_time: UILabel! // ラベル
    
    var previewView = UIView() // カメラ映像表示用ビュー
    var cameraManager = CameraManager() // CameraManagerを利用
    var desiredFrameRate = 30 // フレームレート設定
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let previewLayer = cameraManager.setupCamera(previewView: previewView, delegate: self, desiredFrameRate: desiredFrameRate) {
            // プレビュー表示用レイヤーをビューに追加
            previewLayer.frame = view.bounds
            view.layer.addSublayer(previewLayer)
        }
        
        func setupUI() {
            // プレビュー表示用ビューを設定
            previewView.frame = view.bounds
            view.addSubview(previewView)
            
            // ラベルの位置とサイズを設定
            estimate_cals_time.frame = CGRect(x: 20, y: 40, width: 600, height: 60)
            estimate_cals_time.text = "label set complete"
            view.addSubview(estimate_cals_time)
            
            // ラベルを前面に表示
            view.bringSubviewToFront(estimate_cals_time)
        }
        
        
        
        func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
            // カメラフレームの処理（必要なら追加）
            print("Frame captured")
        }
    }
}
