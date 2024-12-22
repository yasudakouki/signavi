import UIKit
import SwiftUI

class FirstSettingViewController: UIViewController {
    
    @IBOutlet weak var language_text: UILabel! // ラベル
    
    @IBOutlet weak var JP_button: UIButton!
    
    @IBAction func JP_button_func(_ sender: Any) {
        print("tapされた")
        UserDefaults.standard.set(true, forKey: "first_setting_TF")
        print("初期起動を保存しました: true")
        performSegue(withIdentifier: "change_announce_window", sender: nil)
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // 現在の画面サイズを取得
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height

        
        
        
        
        
        // ラベルのフォントサイズを画面サイズに合わせて調整
        let fontSize = min(screenWidth, screenHeight) * 0.1 // 画面幅や高さの5%をフォントサイズに設定
        language_text.font = UIFont.systemFont(ofSize: fontSize)
        // ラベルのサイズを画面幅の70%に変更
        language_text.frame.size.width = screenWidth * 0.7
        // ラベルの位置を中央に設定
        language_text.center = CGPoint(x: screenWidth / 2, y: screenHeight / 4)
         

        
        
        
        
        
        
        
        print("初回起動画面です")
        
        
        
    }

}

