import AVFoundation  // カメラやマイクの制御に必要

// カメラ管理クラス
class CameraManager: NSObject {
    /*
     使用タイミング:
        - このスクリプトを編集する必要がある場合:
            1. カメラの設定（解像度、フレームレート、位置など）を変更したいとき。
            2. カメラのフレームデータを処理する方法を変更または追加したいとき。
            3. カメラの入力や出力の挙動をカスタマイズしたいとき。
     
     継承:
        - NSObject: Objective-CベースのAPI（AVFoundationなど）を利用するために必要。
     
     機能概要:
        - このクラスはカメラの映像入力、出力、プレビュー表示、フレームレート設定を管理します。
        - 他のクラスが映像データを利用できるようにするため、デリゲートを設定してフレームデータを送信します。
    */
    
    // プライベートプロパティ（外部からアクセス不可）
    private var captureSession: AVCaptureSession?  // カメラの映像や音声入力を管理するセッション
    private let videoOutput = AVCaptureVideoDataOutput()  // 映像フレームを出力するオブジェクト（フレーム処理を担当）
    private let videoQueue = DispatchQueue(label: "camera.queue")  // フレーム処理を非同期で実行するためのバックグラウンドキュー（並列処理を行うためのキュー）
    private var desiredFrameRate: Int = 15  // フレームレート設定

    // フレームデータを受け取るデリゲートプロパティ
    var delegate: AVCaptureVideoDataOutputSampleBufferDelegate?  // フレームごとの処理を担当するオブジェクト

    // カメラの初期設定とプレビューを返す関数
    func setupVideo() -> AVCaptureVideoPreviewLayer? {
        /*
         役割:
            - カメラのセッションを作成し、映像入力や出力の設定を行う。
            - セッションを開始してフレームデータの取得を開始する。
         戻り値:
            AVCaptureVideoPreviewLayer: カメラ映像を画面に表示するためのレイヤー
        */
        
        // セッションの開始（カメラ機能を管理するための基盤）
        captureSession = AVCaptureSession()
        

        // カメラデバイスを取得（デフォルトのビデオカメラを選択）
        guard let device = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: device) else {
            print("Error: カメラデバイスの取得に失敗しました")
            return nil
        }
        
        // セッションにカメラ入力を追加（カメラ映像をセッションに流し込む）
        captureSession?.addInput(input)
        
        // 映像出力の設定（フレームごとのデータをデリゲートで送信）
        videoOutput.setSampleBufferDelegate(delegate, queue: videoQueue)
        captureSession?.addOutput(videoOutput)
        
        // 映像方向を縦向き（portrait）に設定
        if let videoConnection = videoOutput.connection(with: .video) {
            if videoConnection.isVideoOrientationSupported {
                videoConnection.videoOrientation = .portrait  // 縦向きに設定
            }
        }

        
        captureSession?.commitConfiguration()  // セッション設定を確定
        

        
        // プレビュー用のレイヤーを設定（画面にカメラ映像を表示する準備）
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        previewLayer.videoGravity = .resizeAspectFill  // 映像を画面全体にフィットさせる
        
//        // セッションを開始（映像データの取得とプレビューの開始）
//        captureSession?.startRunning()
        // セッション開始をバックグラウンドスレッドで実行(紫の警告回避)
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession?.startRunning()
        }
        
        
        
        
        // フレームレートの設定
        do {
            // カメラデバイスをロックして設定変更を可能にする
            try device.lockForConfiguration()
            
            // フレームレート設定（最小・最大フレーム間隔を指定）
            device.activeVideoMinFrameDuration = CMTime(value: 1, timescale: Int32(desiredFrameRate))
            device.activeVideoMaxFrameDuration = CMTime(value: 1, timescale: Int32(desiredFrameRate))
            
            // 設定後にロックを解除
            device.unlockForConfiguration()
            print("Frame rate set to \(desiredFrameRate) FPS")
        } catch {
            // エラーハンドリング（ロックまたはフレームレート設定失敗時）
            print("Error: フレームレート設定に失敗しました: \(error)")
        }
        
        //viewcontrollerにて使うからそれ用のreturnかな？
        return previewLayer  // プレビュー表示用のレイヤーを返す
    }
}
