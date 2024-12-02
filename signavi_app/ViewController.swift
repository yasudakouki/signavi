import UIKit
import AVFoundation

// アプリのメイン画面を管理するクラス
class ViewController: UIViewController {
    /*
     使用タイミング:
        - アプリが起動し、ユーザーがカメラを操作して物体検知を行うとき
        - カメラ映像のプレビューを表示し、物体検知結果をリアルタイムに描画する
     
     役割:
        - CameraManager: カメラの映像を管理
        - ObjectDetector: 物体検知のロジックを実行
        - DetectionDrawer: 検知結果を画面に描画
    */

    // カメラの制御を担当するクラス（CameraManager.swift）
    private let cameraManager = CameraManager()
    
    // CoreMLモデルを使用した物体検知を行うクラス（ObjectDetector.swift）
//    private let objectDetector = ObjectDetector(modelName: "best_640")
    private let objectDetector = ObjectDetector(modelName: "yolo11n")
    /*
     注意:
        - modelNameの "" はプロジェクト内の .mlmodelc ファイルの名前に置き換えてください
        - モデル名が一致しないとロードエラーが発生します
    */
    
    // 検知結果を描画するクラス（DetectionDrawer.swift）
    private let detectionDrawer = DetectionDrawer()
    
    // カメラ映像を表示するためのプレビューレイヤー
    private var previewLayer: AVCaptureVideoPreviewLayer?
    
    // 検知結果を重ねて表示するためのオーバーレイビュー
    private let overlayView = UIImageView()

    // フレームスキップ用プロパティ
    private var frameCounter = 0  // フレームカウンター
    private let frameSkipInterval = 3 // スキップするフレーム間隔  3フレームに1回処理する

    override func viewDidLoad() {
        /*
         役割:
            - 画面が初めてロードされたときに呼び出されるメソッド
            - 初期設定を行う
        */
        super.viewDidLoad()
        
        // カメラのセットアップ
        setupCamera()
        
        // フレーム処理（物体検知と描画）を設定
        setupFrameProcessing()
    }
    
    
    private func setupCamera() {
        /*
         役割:
            - CameraManagerを使用してカメラをセットアップし、プレビューを表示
            - カメラ映像を画面に直接表示する
        */
        
        cameraManager.delegate = self // カメラフレームのデリゲートをViewControllerに設定
        
        // CameraManagerでカメラ映像のプレビューレイヤーを作成
        if let previewLayer = cameraManager.setupVideo() {
            /*
             - previewLayer: カメラ映像を表示するためのレイヤー
             - これを画面全体に合わせるため、`view.bounds` に設定する
            */
            previewLayer.frame = view.bounds // プレビューレイヤーのサイズを画面全体に設定
            previewLayer.connection?.videoOrientation = .portrait  // プレビューの向きを縦向きに設定
            view.layer.addSublayer(previewLayer) // カメラ映像を画面に表示
            self.previewLayer = previewLayer // プレビューレイヤーをプロパティとして保持
        }
        
        // 検知結果を描画するためのオーバーレイビューを設定
        overlayView.frame = view.bounds // オーバーレイビューのサイズを画面全体に設定
        overlayView.contentMode = .scaleAspectFill // 映像を縦横比を維持したまま全体に拡大
        view.addSubview(overlayView) // オーバーレイビューを画面に追加
    }
    
    private func setupFrameProcessing() {
        /*
         役割:
            - カメラフレームが更新されるたびに物体検知を実行し、描画する処理を設定
        */
        cameraManager.delegate = self // カメラフレームのデリゲートをViewController(captureOutput)に設定
    }
}


// AVCaptureVideoDataOutputSampleBufferDelegateに関連するコード
extension ViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    /*
     AVCaptureVideoDataOutputSampleBufferDelegate:
        - カメラフレームのデータをリアルタイムに受け取るためのデリゲート。
        - フレームごとの処理をカスタマイズ可能。
    */
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        /*
         役割:
            - カメラから取得したフレームデータ（sampleBuffer）を処理。
            - 物体検知を実行し、検知結果を描画。
         引数:
            - output: フレームデータの出力元。
            - sampleBuffer: カメラフレームデータ（ピクセルデータ）。
            - connection: 出力元との接続情報。
         */
        
        // フレームスキップ処理
        frameCounter += 1
        if frameCounter % frameSkipInterval != 0 {
            return // このフレームはスキップ
        }
        
        frameCounter = 0 // カウンターをリセット
        // カメラフレームのピクセルデータを取得
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            print("Error: ピクセルバッファの取得に失敗しました")
            return
        }
        
        // 非同期で物体検知を実行（ObjectDetectorを使用）
        objectDetector.performDetection(on: pixelBuffer) { [weak self] observations in
            /*
             performDetectionの結果:
                - detections: 検知結果（ラベル、信頼度、バウンディングボックス）。
                - self: クロージャ内でViewControllerのインスタンスを保持。
             */
            
            guard let self = self, let observations = observations else {
                print("Error: 推論結果がnilです")
                return
            }
            
            // VNRecognizedObjectObservation(observations) を Detection にcompactMapを使用して変換
            let detections: [Detection] = observations.compactMap { observation in
                guard let label = observation.labels.first else {
                    print("Observation \(observation) にラベルが見つかりません")
                    return nil
                }
                return Detection(
                    box: observation.boundingBox,
                    confidence: label.confidence,
                    label: label.identifier,
                    color: .red
                )
            }
            
            // 検知結果を描画（DetectionDrawerを使用）
            DispatchQueue.main.async {
                let renderedImage = self.detectionDrawer.render(detections: detections, on: pixelBuffer)
                self.overlayView.image = renderedImage // 描画結果をオーバーレイビューに設定
            }
        }
    }
}
