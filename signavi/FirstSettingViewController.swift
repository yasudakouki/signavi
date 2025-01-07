import UIKit
import SwiftUI

class FirstSettingViewController: UIViewController {
    
    
    //ボタンやテキストというオブジェクトを紐づけ
    @IBOutlet weak var language_text: UILabel! // ラベル
    
    @IBOutlet weak var JP_button: UIButton!
    
    @IBOutlet weak var EN_button: UIButton!
    
    @IBOutlet weak var KR_button: UIButton!
    
    @IBOutlet weak var CN_button: UIButton!

    //ボタンの動作を紐づけする
    @IBAction func JP_button_func(_ sender: Any) {
        print("JP:tapされた")
        UserDefaults.standard.set(true, forKey: "first_setting_TF")
        UserDefaults.standard.set("JP", forKey: "select_language")
        print("初期起動を保存しました: true")
        performSegue(withIdentifier: "change_announce_window", sender: nil)
    }
    
    
    @IBAction func EN_button_func(_ sender: Any) {
        print("EN:tapされた")
        UserDefaults.standard.set(true, forKey: "first_setting_TF")
        UserDefaults.standard.set("EN", forKey: "select_language")
        print("初期起動を保存しました: true")
        performSegue(withIdentifier: "change_announce_window", sender: nil)
    }
    
    
    @IBAction func KR_button(_ sender: Any) {
        print("KR:tapされた")
        UserDefaults.standard.set(true, forKey: "first_setting_TF")
        UserDefaults.standard.set("KR", forKey: "select_language")
        print("初期起動を保存しました: true")
        performSegue(withIdentifier: "change_announce_window", sender: nil)
    }
    
    
    @IBAction func CN_button(_ sender: Any) {
        print("CN:tapされた")
        UserDefaults.standard.set(true, forKey: "first_setting_TF")
        UserDefaults.standard.set("CN", forKey: "select_language")
        print("初期起動を保存しました: true")
        performSegue(withIdentifier: "change_announce_window", sender: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: ボタン等の設定
        
        // 現在の画面サイズを取得
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height

        
        
        
        
        
        // 画面サイズに基づいてフォントサイズを設定
        let fontSize = min(screenWidth, screenHeight) * 0.1
        language_text.font = UIFont.systemFont(ofSize: fontSize)

        // ラベルが複数行に対応するように設定
        language_text.numberOfLines = 0
        language_text.textAlignment = .left // テキストを中央揃え

        // ラベルの幅を画面の70%に設定
        language_text.frame.size.width = screenWidth * 0.7

        // ラベルのサイズをテキストに合わせて調整
        language_text.sizeToFit()

        // ラベルの位置を中央に設定（高さ調整に注意）
        language_text.center = CGPoint(x: screenWidth / 2, y: screenHeight / 5)

         
        
        
        
        JP_button.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)

        // ラベルのサイズを画面幅の70%に変更
        JP_button.frame.size.width = screenWidth * 0.7
        // ラベルの位置を中央に設定
        JP_button.center = CGPoint(x: screenWidth / 2, y: screenHeight*3 / 7)

        
        
        EN_button.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)

        // ラベルのサイズを画面幅の70%に変更
        EN_button.frame.size.width = screenWidth * 0.7
        // ラベルの位置を中央に設定
        EN_button.center = CGPoint(x: screenWidth / 2, y: screenHeight*4 / 7)

        
        
        
        KR_button.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)

        // ラベルのサイズを画面幅の70%に変更
        KR_button.frame.size.width = screenWidth * 0.7
        // ラベルの位置を中央に設定
        KR_button.center = CGPoint(x: screenWidth / 2, y: screenHeight*5 / 7)

        
        
        CN_button.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)

        // ラベルのサイズを画面幅の70%に変更
        CN_button.frame.size.width = screenWidth * 0.7
        // ラベルの位置を中央に設定
        CN_button.center = CGPoint(x: screenWidth / 2, y: screenHeight*6 / 7)

        
        
        // MARK: FPS設定などの初期を決めておく
        UserDefaults.standard.set(true, forKey: "draw_rectangle")
        UserDefaults.standard.set(20, forKey: "setting_fps_rate")
        
        
        
        print("初回起動画面です")
        
        
        
    }

}

