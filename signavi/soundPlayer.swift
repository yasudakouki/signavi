import UIKit
import AVFoundation

class SoundPlayer: NSObject, AVAudioPlayerDelegate {
    
    // 音源の指定を辞書で管理
    var sounds: [String: NSDataAsset] = [:]
    var lastPlayedTimes: [String: Date] = [:]  // ラベルごとに最後に再生した時間を記録
    var music_player: AVAudioPlayer!
    var lastPlayedEndTime: Date?  // 最後に再生した音声の終了時間

    override init() {
        super.init()
        loadSounds()
    }

    private func loadSounds() {
        let soundNames = [
            "warning_JP", "warning_EN", "warning_KR", "warning_CN",
            "stop_JP", "stop_EN", "stop_KR", "stop_CN",
            "no_parking_JP", "no_parking_EN", "no_parking_KR", "no_parking_CN",
            "speed_30_JP", "speed_30_EN", "speed_30_KR", "speed_30_CN",
            "speed_40_JP", "speed_40_EN", "speed_40_KR", "speed_40_CN",
            "speed_50_JP", "speed_50_EN", "speed_50_KR", "speed_50_CN",
            "slowdown_JP", "slowdown_EN", "slowdown_KR", "slowdown_CN",
            "no_entry_JP", "no_entry_EN", "no_entry_KR", "no_entry_CN",
            "pedestrian_crossing_JP", "pedestrian_crossing_EN", "pedestrian_crossing_KR", "pedestrian_crossing_CN",
            "no_parking_allowed_JP", "no_parking_allowed_EN", "no_parking_allowed_KR", "no_parking_allowed_CN",
            "turning_prohibited_JP", "turning_prohibited_EN", "turning_prohibited_KR", "turning_prohibited_CN",
            "no_overtaking_JP", "no_overtaking_EN", "no_overtaking_KR", "no_overtaking_CN"
        ]
        
        for name in soundNames {
            if let asset = NSDataAsset(name: name) {
                sounds[name] = asset
            } else {
                print("Error: \(name) not found")
            }
        }
    }
    
    // ラベル名と言語を元に音楽を再生
    func musicPlayer(Detection_label: String, language: String = "JP", confidence: Float) {
        // confidenceが設定した閾値より低ければ、ここで再生をスキップ
        let threshold: Float = 0.8  // ← 好きな値に設定
        if confidence < threshold {
            print("Confidence (\(confidence)) は閾値(\(threshold))未満のため音声を流しません")
            return
        }

        // ラベルの変換処理(2パターンある標識ラベルを変換する)
        var label = Detection_label
        if (label == "stop2") {
            label = "stop"
        } else if (label == "slowdown2") {
            label = "slowdown"
        } else if (label == "pedestrian_crossing2") {
            label = "pedestrian_crossing"
        }   

        // 音声再生
        let language = UserDefaults.standard.string(forKey: "select_language") ?? "JP"
        let soundName = "\(label)_\(language)"
        print("Detected objectの値: \(soundName)")
        
        guard let sound = sounds[soundName]?.data else {
            print("エラー発生.音を流せません")
            return
        }
        
        // 再生中の場合は新しい音声を再生しない
        if let lastEndTime = lastPlayedEndTime, Date() <= lastEndTime {
            print("前回の音声がまだ再生中のため、新しい音声を再生しません")
            return
        }
        
        // 同じラベルの音声は30秒以内に再生しない
        if let lastPlayedTime = lastPlayedTimes[soundName], Date().timeIntervalSince(lastPlayedTime) < 30 {
            print("同じラベルの音声は30秒以内に再生されました。再生をスキップします。")
            return
        }
        
        do {
            music_player = try AVAudioPlayer(data: sound)  // 音楽を指定
            music_player.delegate = self  // デリゲートを設定
            music_player.play()  // 音楽再生
            lastPlayedTimes[soundName] = Date()  // 最後に再生した時間を更新
            lastPlayedEndTime = Date().addingTimeInterval(music_player.duration)  // 再生終了時間を設定
        } catch {
            print("エラー発生.音を流せません")
        }
    }

    // 音楽を停止
    func stopAllMusic() {
        if music_player != nil && music_player.isPlaying {
            music_player.stop()
        }
        lastPlayedEndTime = nil  // 再生終了時間をリセット
    }
    
    // 警告音を再生
    func playWarningSound(language: String = "JP") {
        let soundName = "warning_\(language)"
        guard let sound = sounds[soundName]?.data else {
            print("エラー発生.音を流せません")
            return
        }
        
        // 最後に再生した時間をチェック
        if let lastEndTime = lastPlayedEndTime, Date() < lastEndTime {
            print("前回の音声がまだ再生中のため、新しい音声を再生しません")
            return
        }
        
        do {
            music_player = try AVAudioPlayer(data: sound)  // 警告音を指定
            music_player.delegate = self  // デリゲートを設定
            music_player.play()  // 警告音再生
            lastPlayedEndTime = Date().addingTimeInterval(music_player.duration)  // 再生終了時間を設定
        } catch {
            print("エラー発生.音を流せません")
        }
    }
    
    // AVAudioPlayerDelegateメソッド
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        lastPlayedEndTime = nil  // 再生終了時間をリセット
    }
}
