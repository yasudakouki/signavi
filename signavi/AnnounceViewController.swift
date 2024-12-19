import UIKit
import SwiftUI

class AnnounceViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        print("アナウンス画面です")
        print("aaaaaaa")
        sleep(5)
        
    // 5秒後に画面遷移
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.performSegue(withIdentifier: "change_main_window", sender: nil)
        }
        
        
    }
}
