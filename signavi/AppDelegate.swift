import UIKit  // 画面の表示、イベント処理などを提供

// アプリのエントリーポイントを明示。ここ（AppDelegate）をアプリの起点として実行する
// あまり考えなくて良い
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    /*
     継承
        UIRespnder: イベントを受け取り、必要な処理を行う機能を提供
     プロトコル
        UIApplicationDelegate: アプリのライフサイクル（起動、処理、終了とか）に関するイベントを管理
    */
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        /*
         役割
            アプリの起動時に一度だけ呼ばれる
            通常はアプリ全体の初期設定を記述（例: Firebaseの初期化、データベースのセットアップ、etc...）
            正常に起動したらtrueを返す
         
         引数
            applicaition:
                アプリのインスタンス
            launchOptions: 起動オプション情報（例: 通知から起動された場合のデータ）
                - 例: 通知（.remoteNotification）やURLスキーム（.url）からの起動情報
         
         戻り値
            bool: 正常に起動したらtrueを返す
        */
        print("アプリが起動しました")
        return true
    }
    
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        /*
         役割
            新しいシーン（ウィンドウ）を作成する際に呼ばれる
            SceneDelegate.swiftに渡す設定をここで指定
        
         戻り値
            UISceneConfiguration: シーンの名前や役割を指定する設定
        */
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        /*
         役割
            使用されなくなったシーン（ウィンドウ）を破棄する際に呼ばれる
            主に関連リソースの開放処理を記述
        */
        
        // 以下にリソース解放などの処理を記述
    }

}
