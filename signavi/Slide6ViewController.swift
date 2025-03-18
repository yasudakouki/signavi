//
//  Slide6ViewController.swift
//  signavi
//
//  Created by 安田光究 on 2025/03/17.
//

import UIKit

class Slide6ViewController: UIViewController {

    @IBOutlet weak var s6_label: UILabel!
    @IBOutlet weak var openYouTubeButton: UIButton!
    
    @IBAction func openYouTubeLink(_ sender: UIButton) {
        // signavi車窓動画のURLを指定
        if let url = URL(string: "https://youtu.be/YYMRxbJFZds?feature=shared") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 言語を取得
        let language = UserDefaults.standard.string(forKey: "select_language") ?? "JP"

        // 言語ごとに文章を設定
        switch language {
        case "JP":
            s6_label.font = UIFont.systemFont(ofSize: 25)
            s6_label.text = "標識がない場所でもOK！別の端末でsignaviのYouTube動画を流し、そこにスマホを向ければテストできます。"
            openYouTubeButton.setTitle("動画を見る", for: .normal)
        case "EN":
            s6_label.font = UIFont.systemFont(ofSize: 23)
            s6_label.text = "No road signs around? No problem! \n Play signavi's YouTube video on another device and point your phone at it for testing."
            openYouTubeButton.setTitle("View Video", for: .normal)
        case "KR":
            s6_label.font = UIFont.systemFont(ofSize: 23)
            s6_label.text = "표지판이 없는 곳에서도 OK! 다른 기기에서 signavi의 YouTube 영상을 재생하고, 스마트폰을 그쪽으로 비추면 테스트할 수 있습니다."
            openYouTubeButton.setTitle("영상 보기", for: .normal)
        case "CN":
            s6_label.font = UIFont.systemFont(ofSize: 25)
            s6_label.text = "没有实际的路标也没关系！在另一台设备上播放 signavi 的 YouTube 视频，然后对着它举起手机，即可进行测试。"
            openYouTubeButton.setTitle("观看视频", for: .normal)
        default:
            s6_label.text = "標識がない場所でもOK！別の端末でsignaviのYouTube動画を流し、そこにスマホを向ければテストできます。"
            openYouTubeButton.setTitle("動画を見る", for: .normal)
        }
    }
}
