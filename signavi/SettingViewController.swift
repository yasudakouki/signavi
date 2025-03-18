import UIKit
import SwiftUI

class SettingViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // SwiftUIのSettingViewをHostingControllerでラップ
        var settingView = SettingView()
        
        // チュートリアルを開く
        settingView.onShowTutorial = { [weak self] in
            self?.showTutorialFromSettings()
        }
        
        let hostingController = UIHostingController(rootView: settingView)
        
        // HostingControllerのViewを、現在のViewControllerのViewに追加
        addChild(hostingController)
        view.addSubview(hostingController.view)
        
        // Auto Layoutを使用して、HostingControllerのビューの制約を設定
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // 親子関係を設定
        hostingController.didMove(toParent: self)
        
        // ナビゲーションバーを非表示にする
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func showTutorialFromSettings() {
        // TutorialContainerViewController を表示
        if let tutorialVC = storyboard?.instantiateViewController(withIdentifier: "TutorialContainer") as? TutorialContainerViewController {
            tutorialVC.modalPresentationStyle = .fullScreen
            present(tutorialVC, animated: true)
        }
    }
}
