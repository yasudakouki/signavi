import UIKit

class Slide3ViewController: UIViewController {

    @IBOutlet weak var s3_label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 言語を取得
        let language = UserDefaults.standard.string(forKey: "select_language") ?? "JP"

        // 言語ごとに文章を設定
        switch language {
        case "JP":
            s3_label.text = "運転者がスマホを持つのは危険です助手席の方が標識をカメラで狙えば自動で音声が流れます。"
        case "EN":
            s3_label.font = UIFont.systemFont(ofSize: 23)
            s3_label.text = "It's dangerous for the driver to hold the phone. \n Let the passenger aim the camera at road signs to trigger the audio guide."
        case "KR":
            s3_label.font = UIFont.systemFont(ofSize: 23)
            s3_label.text = "운전자가 직접 스마트폰을 들고 있는 것은 위험합니다. 동승자가 카메라로 표지판을 조준하면, 음성이 자동으로 재생됩니다."
        case "CN":
            s3_label.font = UIFont.systemFont(ofSize: 27)
            s3_label.text = "司机拿着手机是很危险的。如果由乘客用相机对准道路标志，系统会自动播放语音提示。"
        default:
            s3_label.text = "運転者がスマホを持つのは危険です助手席の方が標識をカメラで狙えば自動で音声が流れます。"
        }
    }
}
