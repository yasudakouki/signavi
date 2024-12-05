import UIKit
import Vision

class RenderManager {
    private let ciContext = CIContext()
    
    func drawDetections(_ observations: [VNRecognizedObjectObservation], on pixelBuffer: CVPixelBuffer) -> UIImage? {
        // ピクセルバッファを CIImage に変換
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        guard let cgImage = ciContext.createCGImage(ciImage, from: ciImage.extent) else { return nil }
        let imageSize = ciImage.extent.size
        
        // 描画用の CGContext 作成
        guard let context = CGContext(data: nil,
                                       width: Int(imageSize.width),
                                       height: Int(imageSize.height),
                                       bitsPerComponent: 8,
                                       bytesPerRow: 4 * Int(imageSize.width),
                                       space: CGColorSpaceCreateDeviceRGB(),
                                       bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else {
            return nil
        }
        
        // 元画像を描画
        context.draw(cgImage, in: CGRect(origin: .zero, size: imageSize))
        
        // 検知結果を描画
        for observation in observations {
            // 座標変換 (正規化座標 -> ピクセル座標)
            let boundingBox = observation.boundingBox
            let rect = CGRect(
                x: boundingBox.minX * imageSize.width,
                y: (1 - boundingBox.maxY) * imageSize.height,
                width: boundingBox.width * imageSize.width,
                height: boundingBox.height * imageSize.height
            )
            
            // 矩形の描画
            context.setLineWidth(3.0)
            context.setStrokeColor(UIColor.red.cgColor)
            context.stroke(rect)
            
            // ラベルの描画
            if let label = observation.labels.first {
                let labelText = "\(label.identifier) (\(Int(label.confidence * 100))%)"
                let textAttributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont.systemFont(ofSize: 12),
                    .foregroundColor: UIColor.red
                ]
                let textPosition = CGPoint(x: rect.minX, y: rect.minY - 20)
                let attributedText = NSAttributedString(string: labelText, attributes: textAttributes)
                attributedText.draw(at: textPosition)
            }
        }
        
        // 新しい画像を取得
        guard let newImage = context.makeImage() else { return nil }
        return UIImage(cgImage: newImage)
    }
}
