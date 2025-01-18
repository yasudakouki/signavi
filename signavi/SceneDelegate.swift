import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var originalBrightness: CGFloat?



    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        // UIScene が UIWindowScene であることを確認
        guard let windowScene = scene as? UIWindowScene else { return }

        // UIWindowを作成
        let window = UIWindow(windowScene: windowScene)

        // Storyboardの読み込み
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        
        let first_setting_TF = UserDefaults.standard.object(forKey: "first_setting_TF") as? Bool ?? false
        print("取得した値: \(first_setting_TF)")

        // 条件に応じて初期画面を切り替える
        let initialViewController: UIViewController
        if first_setting_TF  {
            initialViewController = storyboard.instantiateViewController(withIdentifier: "AnnounceWindow")
        } else {
            initialViewController = storyboard.instantiateViewController(withIdentifier: "FirstSettingWindow")
        }
        

        // UIWindowの設定
        window.rootViewController = initialViewController
        self.window = window
        window.makeKeyAndVisible()
        
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
        
        print("diddisconnet呼び出し")
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        originalBrightness = UIScreen.main.brightness
        let auto_luminus = UserDefaults.standard.object(forKey: "auto_luminus") as? Bool ?? false
        if auto_luminus {
            UIScreen.main.brightness = 0.1
        }
        print("diddecomeactive呼び出し")
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
        print("willresignactive呼び出し")
        //ホーム等に戻る際に明るさを既存に戻す
        let auto_luminus = UserDefaults.standard.object(forKey: "auto_luminus") as? Bool ?? false
        if auto_luminus {
            
            guard let brightness = originalBrightness else { return }
            UIScreen.main.brightness = brightness
        }
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        print("willenterfore呼び出し")

       
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        
        print("didenterbackground呼び出し")
    }


}

