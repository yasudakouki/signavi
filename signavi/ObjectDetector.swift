import Vision  // CoreMLモデルを利用して推論を行うためのフレームワーク
import CoreML  // CoreMLモデルを操作するためのフレームワーク

// 物体検知を担当するクラス
class ObjectDetector {
    /*
     使用タイミング:
        - CoreMLモデルを使った物体検知を行いたい場合に利用。
        - カメラや静止画データを推論して、検知結果を取得する。
     
     拡張可能なポイント:
        - 別のCoreMLモデルを利用したい場合（新しいモデル名を指定）。
        - 推論後のデータ整形や、モデルに追加の前処理/後処理を追加したい場合。
        - 複数のモデルを切り替えて使いたい場合は、このクラスを拡張して対応。

     このスクリプトを編集する必要がある場合:
        1. 新しいモデルを導入したいとき。
        2. 検知結果の形式を変更したいとき（例えば、独自のデータ型に変換する場合）。
        3. 推論の挙動をカスタマイズしたいとき（例えば、結果のフィルタリングなど）。
    */

    private var model: VNCoreMLModel?  // CoreMLモデルをVisionフレームワークで利用する形式に変換して保持

    // クラスの初期化時にモデルのロードを行う
    init(modelName: String) {
        /*
         コンストラクタ:
            - モデルの名前を指定して初期化。
            - CoreMLモデルをロードし、利用可能な状態にする。
         引数:
            - modelName: CoreMLモデルの名前（拡張子 .mlmodelc は不要）。
         使用例:
            let detector = ObjectDetector(modelName: "yolo")
         */
        loadModel(named: modelName)
    }

    private func loadModel(named modelName: String) {
        /*
         役割:
            - CoreMLモデルをロードして Vision フレームワークで利用可能な形式に変換。
         引数:
            - modelName: ロードするモデルの名前。
         詳細:
            - CoreMLモデルをロードし、それを Vision フレームワークの形式に変換する。
            - Vision フレームワークは、画像認識や物体検知などの処理を容易にするライブラリ。
        */

        // アプリ内のリソースから指定されたモデルのURLを取得
        guard let modelURL = Bundle.main.url(forResource: modelName, withExtension: "mlmodelc") else {
            print("Error: モデル \(modelName) が見つかりません")
            return
        }

        // モデルをロードしてVision用に変換
        do {
            let coreMLModel = try MLModel(contentsOf: modelURL)  // CoreMLモデルのロード
            model = try VNCoreMLModel(for: coreMLModel)  // Vision形式に変換
        } catch {
            print("Error: モデルのロードに失敗しました - \(error)")
        }
    }

    func performDetection(on pixelBuffer: CVPixelBuffer) -> [VNRecognizedObjectObservation]? {
        /*
         役割:
            - フレームデータをモデルに渡して推論を同期的に実行。
            - 推論結果を直接返す。
         引数:
            - pixelBuffer: 推論対象のフレームデータ（カメラや画像から取得）。
         戻り値:
            - 推論結果（`VNRecognizedObjectObservation` 型の配列）、失敗時は `nil`。
         詳細:
            - `VNCoreMLRequest` と `VNImageRequestHandler` を使用して同期的に物体検知を行う。
         */

        guard let model = model else {
            // モデルがロードされていない場合
            print("Error: モデルがロードされていません")
            return nil
        }

        // Visionの物体検知リクエストを作成
        let request = VNCoreMLRequest(model: model)

        // 推論用のリクエストハンドラを作成
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])

        do {
            // ハンドラを使用してリクエストを同期実行
            try handler.perform([request])
        } catch {
            print("Error: 推論リクエストの実行に失敗しました - \(error)")
            return nil
        }

        // 推論結果を `VNRecognizedObjectObservation` 型の配列として取得
        let results = request.results as? [VNRecognizedObjectObservation]
        if let results = results, !results.isEmpty {
            print("Detection results: \(results)")
            return results
        } else {
            print("No objects detected")
            return nil
        }
    }

}
