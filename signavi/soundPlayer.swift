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
            "warning_ja", "warning_en", "warning_ko", "warning_ch",
            "stop_ja", "stop_en", "stop_ko", "stop_ch",
            "no_parking_ja", "no_parking_en", "no_parking_ko", "no_parking_ch",
            "speed_30_ja", "speed_30_en", "speed_30_ko", "speed_30_ch",
            "speed_40_ja", "speed_40_en", "speed_40_ko", "speed_40_ch",
            "speed_50_ja", "speed_50_en", "speed_50_ko", "speed_50_ch",
            "slowdown_ja", "slowdown_en", "slowdown_ko", "slowdown_ch",
            "no_entry_ja", "no_entry_en", "no_entry_ko", "no_entry_ch",
            "pedestrian_crossing_ja", "pedestrian_crossing_en", "pedestrian_crossing_ko", "pedestrian_crossing_ch",
            "no_parking_allowed_ja", "no_parking_allowed_en", "no_parking_allowed_ko", "no_parking_allowed_ch",
            "turning_prohibited_ja", "turning_prohibited_en", "turning_prohibited_ko", "turning_prohibited_ch",
            "no_overtaking_ja", "no_overtaking_en", "no_overtaking_ko", "no_overtaking_ch"
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
    func musicPlayer(Detection_label: String, language: String = "ja") {
        let soundName = "\(Detection_label)_\(language)"
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
            let duration = music_player.duration
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
    func playWarningSound(language: String = "ja") {
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
