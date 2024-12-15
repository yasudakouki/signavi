import UIKit
import AVFoundation

class SoundPlayer: NSObject {
    
    // 音源の指定
    let music_data=NSDataAsset(name: "midnight_echo")!.data
    let stop_sound=NSDataAsset(name: "detect_stop")!.data
    let sign_sound=NSDataAsset(name: "detect_sign")!.data
    
    
    var music_player:AVAudioPlayer!
    
    // ラベル名を元に音楽を再生
    func musicPlayer(Detection_label:String){
        
        do{
            music_player=try AVAudioPlayer(data:sign_sound)   // 音楽を指定
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

