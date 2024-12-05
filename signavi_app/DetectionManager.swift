import UIKit
import AVFoundation
import Vision
import Foundation

class DetectionManager {
    private var yoloRequest: VNCoreMLRequest!
    private var classes: [String] = []

    init() {
        do {
            // CoreMLモデルの読み込み
            let model = try yolo11m_speed_limit_40().model
            guard let classLabels = model.modelDescription.classLabels as? [String] else {
                fatalError("Failed to load class labels")
            }
            self.classes = classLabels
            
            // Vision用のCoreMLモデルに変換
            let vnModel = try VNCoreMLModel(for: model)
            yoloRequest = VNCoreMLRequest(model: vnModel)
        } catch {
            fatalError("Failed to load CoreML model: \(error)")
        }
    }
    
    /// 画像中の物体を同期的に検出する
    func detectObjects(pixelBuffer: CVPixelBuffer) -> [VNRecognizedObjectObservation] {
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
        
        do {
            try handler.perform([self.yoloRequest])
            if let results = self.yoloRequest.results as? [VNRecognizedObjectObservation] {
                return results
            } else {
                return []
            }
        } catch {
            print("Failed to perform detection: \(error)")
            return []
        }
    }
}
