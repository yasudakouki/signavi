import UIKit

// UIResponderクラスを継承し、UIApplicationDelegateプロトコルを採用
// @main属性でこのクラスがアプリケーションのエントリーポイントであることを示す
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    // アプリケーションが起動した直後に呼び出されるメソッド
    // application: 現在のアプリケーションのインスタンス
    // launchOptions: アプリ起動時のオプション情報（通知やURLスキームなど）
    // 戻り値: 正常に起動処理を完了した場合は true を返す
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // カスタマイズ可能な起動時の設定処理を書く場所
        return true // 起動処理が成功したことをシステムに通知
    }

    // MARK: UISceneSession Lifecycle

    // 新しいシーンセッション（画面やウィンドウ）が作成される際に呼び出されるメソッド
    // application: 現在のアプリケーションインスタンス
    // connectingSceneSession: 作成中のシーンセッション情報
    // options: シーン接続時のオプション情報
    // 戻り値: 新しいシーンの設定（UISceneConfigurationオブジェクト）
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // デフォルト設定のシーン構成を返す
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    // シーンセッションが破棄されたときに呼び出されるメソッド
    // application: 現在のアプリケーションインスタンス
    // sceneSessions: 破棄されたシーンセッションのセット
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // シーンが破棄された際に解放するリソースがあればここで処理を記述
        // アプリがバックグラウンドにいるときに破棄された場合もこのメソッドが呼び出される
    }
}
