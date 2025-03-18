import UIKit

class Slide5ViewController: UIViewController {

    @IBOutlet weak var s5_label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 言語を取得
        let language = UserDefaults.standard.string(forKey: "select_language") ?? "JP"

        // 言語ごとに文章を設定
        switch language {
        case "JP":
            s5_label.font = UIFont.systemFont(ofSize: 28)
            s5_label.text = "言語、FPSレート、矩形描画ON/OFFなど、右上の⚙アイコンから設定が可能です。"
        case "EN":
            s5_label.font = UIFont.systemFont(ofSize: 25)
            s5_label.text = "You can configure the language, FPS rate, and rectangle drawing ON/OFF from the gear icon (⚙) at the top right."
        case "KR":
            s5_label.font = UIFont.systemFont(ofSize: 25)
            s5_label.text = "언어, FPS 레이트, 사각형 표시 ON/OFF 등은 오른쪽 상단의 톱니바퀴(⚙) 아이콘에서 설정할 수 있습니다."
        case "CN":
            s5_label.font = UIFont.systemFont(ofSize: 25)
            s5_label.text = "语言、FPS速率、矩形绘制的开启或关闭等设置，都可以通过右上角的齿轮图标(⚙)进行配置。"
        default:
            s5_label.text = "言語、FPSレート、矩形描画ON/OFFなど、右上の \n ⚙アイコンから設定が可能です。"
        }
    }
}
