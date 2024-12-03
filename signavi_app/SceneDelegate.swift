import UIKit  // ユーザインターフェース関連の基本フレームワーク

// UIResponderを継承し、UIWindowSceneDelegateプロトコルに準拠
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    /*
     継承
        UIResponder: シーン（ウィンドウ）内で発生するイベントを処理できる
     プロトコル
        UIWindowSceneDelegate: シーンのライフサイクル（生成、破棄など）管理
    */

    // アプリで表示されるウィンドウを管理
    // 画面全体のルートビューコントローラ（ViewControllerなど）を保持
    var window: UIWindow?

    // MARK: シーンライフサイクル

    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        /*
         役割
            シーン（ウィンドウ）が接続されたタイミングで呼び出される
            シーン（ウィンドウ）を関連づける初期設定を行う
                シーンとは、iOSで複数ウィンドウを扱う仕組みのこと（iPadでのマルチタスクなど）
            何も特別な設定を行わない場合、空のブロック（return）で終了
         
         引数
            - scene: 新しく接続されたシーン
            - session: シーンの状態を管理するセッション情報
            - connectionOptions: シーン接続時のオプション情報（通知やURLから起動された場合のデータ）
         
         将来的に
            ここからViewControllerを表示させたらこ
        */

        guard let _ = (scene as? UIWindowScene) else { return }
        /*
         役割
            sceneがUIWindowSceneとしてキャスト可能かチェック
            特に設定が必要な場合はここでウィンドウやルートビューコントローラを設定
         
         処理の流れ
            sceneはメソッドの引数として渡されたUISceneオブジェクト
            `scene as? UIWindowScene`
                sceneをUIWindowScene型にキャストしようとする。
                成功すればUIWindowSceneオブジェクトを返し、失敗すればnil。
                ただし、返り値は `_` に格納されるため使用されない
                elseの時(nil)ならreturnでguard文により終了
        */
    }

    
    func sceneDidDisconnect(_ scene: UIScene) {
        /*
         役割
            シーン（ウィンドウ）が切断された時に呼び出される
            アプリのリソースを開放す場合に使用
         引数
            - scene: 切断されたシーン
         補足
            iOSではバックグラウンドで動作するアプリはシーンが切断される場合がある
        */
    }

    
    func sceneDidBecomeActive(_ scene: UIScene) {
        /*
         役割
            シーンがアクティブになった（フォアグラウンドに戻った）時に呼び出される
         引数
            - scene: アクティブになったシーン
         補足
            一時停止していた処理を再開する際に使用
        */
    }

    
    func sceneWillResignActive(_ scene: UIScene) {  // 関数名にタイポ修正 (sece → scene)
        /*
         役割
            シーンが非アクティブ（バックグラウンドや一時停止状態）になる前に呼び出される
         引数
            - scene: 非アクティブになるシーン
         補足
            処理を一時停止したり、リソースを解放する場合に使用
        */
    }

    
    func sceneWillEnterForeground(_ scene: UIScene) {
        /*
         役割
            シーンがバックグラウンドからフォアグラウンドに復帰する直前に呼び出される
         引数
            - scene: フォアグラウンドに移行するシーン
         補足
            ユーザーが操作可能な状態になる前に、更新が必要なデータをロードするなどの処理を行う
         */
    }

    
    func sceneDidEnterBackground(_ scene: UIScene) {
        /*
         役割
            シーンがバックグラウンドに移行したときに呼び出される
         引数
            - scene: バックグラウンドに移行したシーン
         補足
            ユーザーデータの保存や、現在のアプリ状態の保存を行う
         */
    }
}
