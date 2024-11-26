import UIKit
import AVFoundation

class SoundPlayer: NSObject {
    
    let music_data=NSDataAsset(name: "midnight_echo")!.data   // 音源の指定
    var music_player:AVAudioPlayer!
    
    // 音楽を再生
    func musicPlayer(){
        
        do{
            music_player=try AVAudioPlayer(data:music_data)   // 音楽を指定
            music_player.play()   // 音楽再生
        }catch{
            print("エラー発生.音を流せません")
        }
        
    }

    // 音楽を停止
    func stopAllMusic (){
        music_player?.stop()
    }
}

