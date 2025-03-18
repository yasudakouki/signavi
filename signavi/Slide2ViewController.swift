import UIKit

class Slide2ViewController: UIViewController {

    
    @IBOutlet weak var s2_label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 言語を取得
        let language = UserDefaults.standard.string(forKey: "select_language") ?? "JP"

        // 言語ごとに文章を設定
        switch language {
        case "JP":
            s2_label.text = "道路標識をリアルタイムに検出し、多言語音声で通知します。"
        case "EN":
            s2_label.text = "Detect road signs in real time and notify you with multilingual voice."
        case "KR":
            s2_label.text = "도로 표지를 실시간으로 감지하고 다국어 음성으로 안내합니다."
        case "CN":
            s2_label.text = "实时检测道路标志并通过多语言语音进行通知"
        default:
            s2_label.text = "道路標識をリアルタイムに検出し、多言語音声で通知します。"
        }
    }
}
