import UIKit
import SwiftUI

class SettingViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // SwiftUIのSettingViewをHostingControllerでラップ
        let settingView = SettingView()
        let hostingController = UIHostingController(rootView: settingView)
        
        // HostingControllerのViewを、現在のViewControllerのViewに追加
        addChild(hostingController)
        hostingController.view.frame = view.bounds
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
    }
}

