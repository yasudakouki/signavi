import UIKit

// 検出結果を描画するクラス
class DetectionDrawer {
    /*
     使用タイミング:
        - 物体検知の結果をカメラ映像上に可視化する際に利用
        - 検知結果をデバッグする場合や、ユーザーに結果をわかりやすく伝えるために描画する
     
     拡張や改造が必要な場合:
        1. 描画のスタイルを変更する場合:
            - バウンディングボックスのデザインや色の変更
            - 信頼度の表示方法（例えば、パーセンテージの丸め）
        2. 描画対象が増える場合:
            - 新しいタイプのラベルや特定のアイコンを追加。
        3. パフォーマンス改善が必要な場合:
            - 高解像度画像で処理速度が遅い場合は、`CIContext` や `CGContext` の設定を調整。
     
     役割:
        - Core Image (CIImage)を使ってカメラ映像に検知結果を描画。
        - 検知結果はバウンディングボックス（Bounding Box）やラベルとして表示。
        - 描画後の画像を `UIImage` として返す。
    */
    
    private let ciContext: CIContext  // Core Image の描画処理をサポートするオブジェクト
    
    // 初期化メソッド
    init() {
        ciContext = CIContext()  // Core Image のコンテキストを初期化
    }
    
    // 描画処理を行うメイン関数
    func render(detections: [Detection], on pixelBuffer: CVPixelBuffer) -> UIImage? {
        /*
         役割:
            - カメラ映像のフレーム(pixelBuffer)に検知結果を重ねて描画
            - 描画結果を UIImage として返す
         
         引数:
            - detections: 検出結果（ラベルやバウンディングボックス）を含む配列
            - pixelBuffer: 元となるカメラ映像のフレームデータ
         
         戻り値:
            UIImage: 描画結果が反映されたもの（描画に失敗したらnil）
         
         注意点:
            - `detections` が空の場合は、元の画像のみを返す。
        */
        
        // pixelBufferをCore Imageの形式(CIImage)に変換
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        
        // Core ImageからCGIamgeを生成（描画対象の画像データ）
        guard let cgImage = ciContext.createCGImage(ciImage, from: ciImage.extent) else {
            print("Error: Failed to create CGImage")
            return nil
        }
        
        // 描画対象のサイズを取得（元画像のサイズに合わせる）
        let size = ciImage.extent.size
        
        // グラフィックコンテキストの作成
        guard let cgContext = CGContext(
            data: nil,
            width: Int(size.width),
            height: Int(size.height),
            bitsPerComponent: 8,  // ピクセルごとの色情報のビット数（8ビットカラー）
            bytesPerRow: 4 * Int(size.width),  // 1行あたりのバイト数（RGBA形式なので4倍）
            space: CGColorSpaceCreateDeviceRGB(),  // RGBカラースペースを指定
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue  // アルファ情報を末尾に配置
        ) else {
            print("Error: Failed to create CGContext")
            return nil
        }
        
        print("cgContext created: \(cgContext)")
        
        // 背景画像（元のカメラ映像）を描画
        cgContext.draw(cgImage, in: CGRect(origin: .zero, size: size))
        
        // 各検出結果（バウンディングボックスとラベル）を描画
        for detection in detections {
            print("Drawing detection: \(detection.label ?? "unknown") with confidence \(detection.confidence)")
            drawBoundingBox(detection, on: cgContext, size: size)
        }

        
        // 描画結果をCGImageとして取得し、UIImageとして変換して返す
        guard let newImage = cgContext.makeImage() else {
            print("Error: 描画結果のCGImage生成に失敗しました")
            return nil
        }
        
        return UIImage(cgImage: newImage) // 完成した画像を返す
    }
    
    private func drawBoundingBox(_ detection: Detection, on context: CGContext, size: CGSize) {
        /*
         役割:
            - 単一の検出結果（バウンディングボックスとラベル）を描画。
         引数:
            - detection: 描画対象の検出結果（座標、ラベル、色などを含む）。
            - context: 描画に使用するグラフィックコンテキスト。
            - size: 描画対象画像のサイズ（横幅と高さ）。
         
         補足:
            - バウンディングボックスのスタイルを変更する際はここを編集。
        */
        
        // バウンディングボックスの座標を変換（上下反転を修正）
//        let invertedBox = CGRect(
//            x: detection.box.minX,
//            y: size.height - detection.box.maxY,
//            width: detection.box.width,
//            height: detection.box.height
//        )
        let invertedBox = CGRect(
            x: detection.box.minX * size.width,
            y: (1 - detection.box.maxY) * size.height, // Y座標を反転
            width: detection.box.width * size.width,
            height: detection.box.height * size.height
        )

        // 枠線を描画
        context.setStrokeColor(detection.color.cgColor)  // 枠線の色
        context.setLineWidth(3.0)  // 枠線の太さ
        context.stroke(invertedBox)  // 枠線を描画

        // ラベルを描画
        if let label = detection.label {
            drawLabel(label, confidence: detection.confidence, on: context, box: invertedBox)
        }
    }
    
    private func drawLabel(_ label: String, confidence: Float, on context: CGContext, box: CGRect) {
        /*
         役割:
            - バウンディングボックスに対応するラベル（テキスト）を描画。
         
         引数:
            - label: 描画するラベルの文字列。
            - confidence: 検出信頼度（0.0〜1.0）。
            - context: 描画に使用するグラフィックコンテキスト。
            - box: バウンディングボックスの座標。
         
         補足:
            - ラベルのフォントやスタイルを変更する場合はここを編集。
        */
        
        // ラベルのテキスト内容
        let labelText = "\(label) \(Int(confidence * 100))%"  // 例: "stop 85%"
        
        // テキストスタイルを設定
        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14.0, weight: .bold),
            .foregroundColor: UIColor.white
        ]
        
        // テキストサイズを計算
        let textSize = labelText.size(withAttributes: textAttributes)
        
        // テキストの描画位置を計算
        let textRect = CGRect(
            x: box.minX,
            y: box.minY - textSize.height,
            width: textSize.width,
            height: textSize.height
        )
        
        // テキスト背景を描画（視認性を高めるため）
        context.setFillColor(UIColor.black.withAlphaComponent(0.7).cgColor)
        context.fill(textRect)

        // テキストを描画
        let attributedString = NSAttributedString(string: labelText, attributes: textAttributes)
        let framesetter = CTFramesetterCreateWithAttributedString(attributedString)
        let framePath = CGPath(rect: textRect, transform: nil)
        let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, attributedString.length), framePath, nil)

        // Core Text を使用してテキストを描画
        CTFrameDraw(frame, context)
    }

}
