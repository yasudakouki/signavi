import UIKit

class Slide4ViewController: UIViewController {

    @IBOutlet weak var s4_label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 言語を取得
        let language = UserDefaults.standard.string(forKey: "select_language") ?? "JP"

        // 言語ごとに文章を設定
        switch language {
        case "JP":
            s4_label.text = "１人で運転のときはスマホをダッシュボードに固定。signaviが標識を捉えたら、音声が流れます。"
        case "EN":
            s4_label.font = UIFont.systemFont(ofSize: 25)
            s4_label.text = "Driving alone? Fix your phone on the dashboard. signavi detects road signs and plays audio automatically."
        case "KR":
            s4_label.font = UIFont.systemFont(ofSize: 24)
            s4_label.text = "혼자 운전할 때는 스마트폰을 대시보드에 고정하세요. signavi가 표지판을 인식하면 음성이 자동으로 재생됩니다."
        case "CN":
            s4_label.font = UIFont.systemFont(ofSize: 27)
            s4_label.text = "一个人开车时，将智能手机固定在仪表板上。一旦 signavi 检测到路标，就会自动播放语音提示。"
        default:
            s4_label.text = "１人で運転のときはスマホをダッシュボードに固定。signaviが標識を捉えたら、音声が流れます。"
        }
    }
}
