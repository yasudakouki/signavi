import UIKit
import SwiftUI

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
      
    /*
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        
       
      // UIWindowのインスタンスを作成
      window = UIWindow(frame: UIScreen.main.bounds)

      // Storyboardをロード
      let storyboard = UIStoryboard(name: "Main", bundle: nil)

      // 表示したいViewControllerをStoryboard IDで取得
      let initialViewController: UIViewController
      if true { // 条件に応じて画面を切り替える
          initialViewController = storyboard.instantiateViewController(withIdentifier: "AnnounceWindow")
      }

      // 初期のViewControllerを設定
      window?.rootViewController = initialViewController
      window?.makeKeyAndVisible()

      return true
    }
    */


    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}
