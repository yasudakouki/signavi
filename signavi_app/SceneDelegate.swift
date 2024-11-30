import UIKit

// SceneDelegateクラスはUIResponderを継承している
// UIWindowSceneDelegateプロトコルを採用しており、シーン（画面やウィンドウ）ごとのライフサイクルを管理する
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    // ウィンドウを保持するプロパティ
    // アプリの画面（ViewControllerなど）のルートとして動作する
    var window: UIWindow?

    // MARK: シーンライフサイクル

    // シーン（ウィンドウ）が接続されたときに呼び出される
    // シーンとは、iOSで複数ウィンドウを扱う仕組みのこと（iPadでのマルチタスクなど）
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // このメソッドでウィンドウ（window）をシーン（scene）に関連付けたり、
        // 初期画面を設定したりする
        guard let _ = (scene as? UIWindowScene) else { return }
        // `_`はsceneがウィンドウシーンであることを確認するためのチェック
        // 何も特別な設定を行わない場合、空のブロック（return）で終了
    }

    // シーンが切断されたときに呼び出される
    // シーンがメモリから解放されるタイミング
    func sceneDidDisconnect(_ scene: UIScene) {
        // ユーザーがシーンを閉じた場合や、システムがリソース節約のためにシーンを解放する場合
        // シーンに関連付けられたリソースを解放する処理を行う
    }

    // シーンがアクティブになったときに呼び出される
    // 画面がユーザー操作可能な状態になったタイミング
    func sceneDidBecomeActive(_ scene: UIScene) {
        // アプリがフォアグラウンドに復帰した際にタスクを再開したり、
        // アニメーションや更新を再開する場合に利用
    }

    // シーンが非アクティブになるときに呼び出される
    // ユーザーがアプリを一時的に離れる場合（例: 電話の受信など）
    func sceneWillResignActive(_ scene: UIScene) {
        // 動作を一時停止する処理を記述
        // 一時的にリソースを節約したい場合や、状態を保存する際に利用
    }

    // シーンがバックグラウンドからフォアグラウンドに移行するときに呼び出される
    func sceneWillEnterForeground(_ scene: UIScene) {
        // アプリがバックグラウンドから復帰した際に、必要なリフレッシュ処理を実行
        // 例: ユーザーインターフェイスの再描画やデータの再読み込み
    }

    // シーンがフォアグラウンドからバックグラウンドに移行したときに呼び出される
    func sceneDidEnterBackground(_ scene: UIScene) {
        // アプリがバックグラウンドに移行する際に、データ保存やリソース解放を行う
        // 必要であれば現在の状態を保存し、再びアクティブになる際に復元できるようにする
    }
}
