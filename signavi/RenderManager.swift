import UIKit
import CoreGraphics
import CoreImage

class RenderManager {
    
    // CIContextを初期化
    private let ciContext = CIContext()
    

    // 検出結果を画面に描画する関数
    func render(detections: [Detection], pixelBuffer: CVPixelBuffer, onView view: UIView,videoSize: CGSize , RectVisible: Bool) -> UIImage {
        // 以前の描画を消去
        //view.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        //view.subviews.forEach { $0.removeFromSuperview() }
        
        if RectVisible == true {
            let drawImage = self.drawRectsOnImage(detections, pixelBuffer, videoSize: videoSize)!
            
            return drawImage
            
        }else{
            let drawImage = self.drawImageWithoutDetection(
                pixelBuffer, videoSize: videoSize)!
            
            return drawImage
        }
            
            

        
        //return drawImage
    }

    // バウンディングボックスを描画する関数
    func drawRectsOnImage(_ detections: [Detection], _ pixelBuffer: CVPixelBuffer, videoSize: CGSize) -> UIImage? {
        // CIImageに変換
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        
        // CIContextを使ってCGImageを作成
        guard let cgImage = ciContext.createCGImage(ciImage, from: ciImage.extent) else { return nil }
        
        let size = ciImage.extent.size

        // CGContextを作成して描画準備
        guard let cgContext = CGContext(data: nil,
                                        width: Int(videoSize.width),
                                        height: Int(videoSize.height),
                                        bitsPerComponent: 8,
                                        bytesPerRow: 4 * Int(videoSize.width),
                                        space: CGColorSpaceCreateDeviceRGB(),
                                        bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else { return nil }
        
        // 元の画像を描画
        cgContext.draw(cgImage, in: CGRect(origin: .zero, size: size))
        
        // 検出結果の矩形とラベルを描画
        for detection in detections {
            // 矩形の座標変換 (y軸を反転)
            let invertedBox = CGRect(x: detection.box.minX, y: size.height - detection.box.maxY, width: detection.box.width, height: detection.box.height)
            
            // 矩形を描画
            cgContext.setStrokeColor(detection.color.cgColor)
            cgContext.setLineWidth(2)
            cgContext.stroke(invertedBox)
            
            // ラベルとconfidenceを描画
            if let label = detection.label {
                let confidenceText = String(format: "%.2f", detection.confidence)
                let labelText = "\(label) (\(confidenceText))"
                
                let textAttributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont.systemFont(ofSize: 16),
                    .foregroundColor: detection.color
                ]
                
                let attributedText = NSAttributedString(string: labelText, attributes: textAttributes)
                let textSize = attributedText.size()
                
                // テキストを矩形の上に配置
                let textPosition = CGPoint(x: invertedBox.minX, y: invertedBox.minY - textSize.height)
                let textRect = CGRect(origin: textPosition, size: textSize)
                
                // 描画用のNSAttributedStringをCoreTextを使って描画
                let textPath = CGMutablePath()
                textPath.addRect(textRect)
                
                let framesetter = CTFramesetterCreateWithAttributedString(attributedText)
                let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, attributedText.length), textPath, nil)
                
                CTFrameDraw(frame, cgContext)
            }
        }
        
        
        
        // 描画した画像を作成して返す
        guard let newImage = cgContext.makeImage() else { return nil }
        return UIImage(cgImage: newImage)
    }
    
    
    
    // カメラ映像のみを描画する関数
    func drawImageWithoutDetection(_ pixelBuffer: CVPixelBuffer, videoSize: CGSize) -> UIImage? {
        // CIImageに変換
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)

        // CIContextを使ってCGImageを作成
        guard let cgImage = ciContext.createCGImage(ciImage, from: ciImage.extent) else { return nil }

        let size = ciImage.extent.size

        // CGContextを作成して描画準備
        guard let cgContext = CGContext(data: nil,
                                        width: Int(videoSize.width),
                                        height: Int(videoSize.height),
                                        bitsPerComponent: 8,
                                        bytesPerRow: 4 * Int(videoSize.width),
                                        space: CGColorSpaceCreateDeviceRGB(),
                                        bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else { return nil }

        // 元の画像を描画
        cgContext.draw(cgImage, in: CGRect(origin: .zero, size: size))

        // 描画した画像を作成して返す
        guard let newImage = cgContext.makeImage() else { return nil }
        return UIImage(cgImage: newImage)
    }



}
