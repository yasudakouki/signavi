import UIKit

// 検出結果を表す構造体
struct Detection {
    let box: CGRect  // 検出領域の座標とサイズを格納
    let confidence: Float  // 検出結果の信頼度（0.0〜1.0の範囲）
    let label: String?  // 検出された物体のラベル（例: "車", "人"）
    let color: UIColor  // 描画用の色
}
