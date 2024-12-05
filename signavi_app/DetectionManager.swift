import UIKit
import Vision
import CoreML

class DetectionManager {
    private var yoloRequest: VNCoreMLRequest!
    private var classes: [String] = []
    private var videoSize: CGSize
    /// 初期化: CoreMLモデルの読み込み
    init(videoSize: CGSize) {
        self.videoSize = videoSize

        do {
            // モデルを指定して読み込む
            let model = try yolov8n().model
            let vnModel = try VNCoreMLModel(for: model)
            self.yoloRequest = VNCoreMLRequest(model: vnModel)

            // クラス名の取得
            if let classLabels = model.modelDescription.classLabels as? [String] {
                self.classes = classLabels
            }
        } catch {
            fatalError("Failed to initialize DetectionManager: \(error)")
        }
    }

    /// 物体検知を実行し、結果を返す
    func detectObjects(pixelBuffer: CVPixelBuffer , videoSize: CGSize) -> [Detection] {
        do {
            // Visionのリクエストハンドラーを作成
            let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
            try handler.perform([yoloRequest])
            
            guard let results = yoloRequest.results as? [VNRecognizedObjectObservation] else {
                return []
            }

            var detections: [Detection] = []
            for result in results {
                // バウンディングボックスの位置調整
                let flippedBox = CGRect(
                    x: result.boundingBox.minX,
                    y: 1 - result.boundingBox.maxY,
                    width: result.boundingBox.width,
                    height: result.boundingBox.height
                )
                print("detectionによる呼び出し\(videoSize.width), \(videoSize.height)")
                //let box = VNImageRectForNormalizedRect(flippedBox, Int(1080), Int(1920))
                let box = VNImageRectForNormalizedRect(flippedBox, Int(videoSize.width), Int(videoSize.height))

                // ラベル取得とDetectionオブジェクト生成
                if let label = result.labels.first?.identifier {
                    let detection = Detection(box: box, confidence: result.confidence, label: label, color:UIColor.red)
                    detections.append(detection)
                }
            }

            return detections
        } catch {
            print("Detection error: \(error)")
            return []
        }
    }
}
