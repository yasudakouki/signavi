import UIKit
import SwiftUI

class AnnounceViewController: UIViewController {
    
    @IBOutlet weak var announce_text: UILabel! // ラベル
    var soundPlayer = SoundPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // 現在の画面サイズを取得
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        print("screenWidth: \(screenWidth)")
        print("screenWidth: \(screenHeight)")
        
        
        let select_language = UserDefaults.standard.string(forKey: "select_language") ?? "EN"
        let announce_sec = 8
        
        soundPlayer.playWarningSound(language: select_language)  // 警告音を再生

        switch select_language {
        case "JP":
            announce_text.text = "これは補助アプリです \n 気を付けて運転してください"
        case "EN":
            announce_text.text = "Don't rely too much on the app. \n Drive carefully."
        case "KR":
            announce_text.text = "앱에 너무 의존하지 마세요.\n안전 운전하세요."
        case "CN":
            announce_text.text = "不要过度依赖此应用。\n请小心驾驶。"
        default:
            announce_text.text = "select_error"
        }
        
        print("アナウンス画面です")
        print("aaaaaaa")
        
        // 5秒後に画面遷移
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(announce_sec)) {
            self.performSegue(withIdentifier: "change_main_window", sender: nil)
        }
        
        
    }
}
