import UIKit

class Slide1ViewController: UIViewController {

    @IBOutlet weak var s1_welcomeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 言語を取得
        let language = UserDefaults.standard.string(forKey: "select_language") ?? "JP"

        // 言語ごとに文章を設定
        switch language {
        case "JP":
            s1_welcomeLabel.text = "ようこそ！"
        case "EN":
            s1_welcomeLabel.text = "Welcome!"
        case "KR":
            s1_welcomeLabel.text = "환영합니다!"
        case "CN":
            s1_welcomeLabel.text = "欢迎！"
        default:
            s1_welcomeLabel.text = "ようこそ"
        }
    }
}
