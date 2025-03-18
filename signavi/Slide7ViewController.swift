import UIKit

class Slide7ViewController: UIViewController {

    @IBOutlet weak var s7_label: UILabel!
    @IBOutlet weak var s7_label2: UILabel!
    
    @IBOutlet weak var finishTutorialButton: UIButton!
    
    @IBAction func finishTutorialButtonTapped(_ sender: UIButton) {
        // 1. チュートリアル完了フラグを true にする
        UserDefaults.standard.set(true, forKey: "hasSeenTutorial")

        // 2. メイン画面へSegueで遷移
        performSegue(withIdentifier: "TutorialToMain", sender: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 言語を取得
        let language = UserDefaults.standard.string(forKey: "select_language") ?? "JP"

        // 言語ごとに文章を設定
        switch language {
        case "JP":
            s7_label.font = UIFont.systemFont(ofSize: 25)
            s7_label2.font = UIFont.systemFont(ofSize: 25)
            s7_label.text = "安全運転を最優先に！本アプリはあくまでもサポートであり、運転中は周囲状況に集中してください。"
            s7_label2.text = "チュートリアルの再確認は設定画面から可能です"
            finishTutorialButton.setTitle("開始する", for: .normal)
        case "EN":
            s7_label.font = UIFont.systemFont(ofSize: 25)
            s7_label2.font = UIFont.systemFont(ofSize: 25)
            s7_label.text = "Safety first! This app only assists you, so stay alert while driving."
            s7_label2.text = "You can revisit this tutorial anytime from Settings."
            finishTutorialButton.setTitle("Start", for: .normal)
        case "KR":
            s7_label.font = UIFont.systemFont(ofSize: 24)
            s7_label2.font = UIFont.systemFont(ofSize: 24)
            s7_label.text = "안전 운전을 최우선으로 하세요! 이 앱은 어디까지나 보조 수단이므로, 운전 중에는 주변 상황에 집중해 주시기 바랍니다."
            s7_label2.text = "튜토리얼은 설정 화면에서 언제든지 다시 확인하실 수 있습니다."
            finishTutorialButton.setTitle("시작", for: .normal)
        case "CN":
            s7_label.font = UIFont.systemFont(ofSize: 27)
            s7_label2.font = UIFont.systemFont(ofSize: 27)
            s7_label.text = "请优先确保安全驾驶！本应用仅作为辅助工具，驾驶时请专注于周围情况。"
            s7_label2.text = "您可在设置界面随时重新查看本教程。"
            finishTutorialButton.setTitle("开始", for: .normal)
        default:
            s7_label.text = "安全運転を最優先に！本アプリはあくまでもサポートであり、運転中は周囲状況に集中してください"
            s7_label2.text = "チュートリアルの再確認は設定画面から可能です。"
            finishTutorialButton.setTitle("開始する", for: .normal)
        }
    }
}
