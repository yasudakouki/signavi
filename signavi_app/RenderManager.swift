import UIKit
import CoreGraphics
import CoreImage

class RenderManager {
    
    // CIContextを初期化
    private let ciContext = CIContext()
    

    // 検出結果を画面に描画する関数
    func render(detections: [Detection], pixelBuffer: CVPixelBuffer, onView view: UIView,videoSize: CGSize) -> UIImage {
        // 以前の描画を消去
        //view.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        //view.subviews.forEach { $0.removeFromSuperview() }

        let drawImage = self.drawRectsOnImage(detections, pixelBuffer, videoSize: videoSize)!
        
        return drawImage
    }

    // バウンディングボックスを描画する関数
    func drawRectsOnImage(_ detections: [Detection], _ pixelBuffer: CVPixelBuffer,videoSize: CGSize) -> UIImage? {
        // CIImageに変換
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        
        // CIContextを使ってCGImageを作成
        guard let cgImage = ciContext.createCGImage(ciImage, from: ciImage.extent) else { return nil }
        
        let size = ciImage.extent.size
        
        print("renderによる呼び出し\(videoSize.width), \(videoSize.height)")
        
        // CGContextを作成して描画準備
        guard let cgContext = CGContext(data: nil,
                                        width: Int(1080),
                                        height: Int(1920),
                                        bitsPerComponent: 8,
                                        bytesPerRow: 4 * Int(1080),
                                        space: CGColorSpaceCreateDeviceRGB(),
                                        bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else { return nil }
        
        // 元の画像を描画
        cgContext.draw(cgImage, in: CGRect(origin: .zero, size: size))
        
        // 検出結果の矩形を描画
        for detection in detections {
            let invertedBox = CGRect(x: detection.box.minX, y: size.height - detection.box.maxY, width: detection.box.width, height: detection.box.height)
            
            cgContext.setStrokeColor(detection.color.cgColor)
            cgContext.setLineWidth(2) // 四角形の線の太さ
            
            // バウンディングボックスを描画
            cgContext.stroke(invertedBox)
        }
        
        // 描画した画像を作成して返す
        guard let newImage = cgContext.makeImage() else { return nil }
        return UIImage(ciImage: CIImage(cgImage: newImage))
    }
}
