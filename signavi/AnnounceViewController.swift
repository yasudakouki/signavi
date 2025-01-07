import UIKit
import SwiftUI

class AnnounceViewController: UIViewController {
    
    @IBOutlet weak var announce_text: UILabel! // ラベル
    var soundPlayer = SoundPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        soundPlayer.playWarningSound()  // 警告音を再生
        
        
        // 現在の画面サイズを取得
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        
        let select_language = UserDefaults.standard.string(forKey: "select_language") ?? "EN"

        switch select_language {
        case "JP":
            announce_text.text = "これは補助アプリです \n 気を付けて運転してください"
        case "EN":
            announce_text.text = "Don't rely too much on the app. \n Drive carefully."
        case "KR":
            announce_text.text = "한국어"
        case "CN":
            announce_text.text = "中文"
        default:
            announce_text.text = "select_error"
        }
        
        // 画面サイズに基づいてフォントサイズを設定
        let fontSize = min(screenWidth, screenHeight) * 0.06
        announce_text.font = UIFont.systemFont(ofSize: fontSize)

        
        
        // ラベルが複数行に対応するように設定
        announce_text.numberOfLines = 0
        announce_text.textAlignment = .left // 
        // ラベルの幅を画面の70%に設定
        announce_text.frame.size.width = screenWidth * 0.7

        // ラベルのサイズをテキストに合わせて調整
        announce_text.sizeToFit()

        // ラベルの位置を中央に設定（高さ調整に注意）
        announce_text.center = CGPoint(x: screenWidth / 2, y: screenHeight *  3 / 5)
        
    
        print("アナウンス画面です")
        print("aaaaaaa")
        
    // 5秒後に画面遷移
        DispatchQueue.main.asyncAfter(deadline: .now()+5) {
            self.performSegue(withIdentifier: "change_main_window", sender: nil)
        }
        
        
    }
}
