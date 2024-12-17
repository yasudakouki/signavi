import SwiftUI

struct SettingView: View {
    
    var cameraManager = CameraManager() 
    
    @State private var draw_rectangle: Bool = UserDefaults.standard.bool(forKey: "draw_rectangle")
    @State private var isVibrationOn: Bool = UserDefaults.standard.bool(forKey: "isVibrationOn")
    @State private var screenBrightness: Float = Float(UIScreen.main.brightness) // 初期値を現在の明るさに設定
    
    @State private var auto_luminus: Bool = UserDefaults.standard.bool(forKey: "auto_luminus")
    
    @State private var setting_fps_rate: Float = UserDefaults.standard.float(forKey: "setting_fps_rate")

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "arrow.left") // 戻るボタンのアイコン
                        Text("Back")
                    }
                    .foregroundColor(.blue)
                }
                Spacer()
            }
            .padding()

            Form {
                Section(header: Text("View setting")) {
                    Toggle("draw rectangle", isOn: $draw_rectangle)
                    // Toggle("Vibration", isOn: $isVibrationOn)
                }
                
                Section(header: Text("Screen Brightness")) {
                    VStack(alignment: .leading) {
                        // 自動設定トグル
                        VStack(alignment: .leading) {
                            Toggle("Luminous Auto Setting", isOn: $auto_luminus)
                        }
                        
                        Divider() // セクションの間に線を追加

                        // 明るさ調整スライダー
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Brightness")
                                Slider(value: $screenBrightness, in: 0...1, step: 0.01) {
                                }
                                .onChange(of: screenBrightness) { newValue in
                                    UIScreen.main.brightness = CGFloat(newValue) // 明るさを調整
                                }
                            }
                        }
                    }
                }
                //Divider() // セクションの間に線を追加
                
                Section(header: Text("camera FPS setting")) {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Camera FPS: \(Int(setting_fps_rate))") // FPSの値を表示
                            
                            Slider(value: $setting_fps_rate, in: 10...30, step: 1)
                                .onChange(of: setting_fps_rate) { newValue in
                                    // 新しい値をUserDefaultsに保存
                                    UserDefaults.standard.set(newValue, forKey: "setting_fps_rate")
                                    print("New FPS value saved: \(newValue)")
                                }
                        }
                    }
                    .padding()
                    .onAppear {
                        // Viewが表示される時に最新のFPS値をUserDefaultsから読み込む
                        setting_fps_rate = UserDefaults.standard.float(forKey: "setting_fps_rate")
                    }
                }

                
                Section(header: Text("Save:")) {
                    Button(action: {
                        // 設定を保存
                        UserDefaults.standard.set(self.draw_rectangle, forKey: "draw_rectangle")
                        UserDefaults.standard.set(self.isVibrationOn, forKey: "isVibrationOn")
                        print("save was tapped")
                        
                        // 保存後に前の画面に戻る
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Spacer()
                            Text("Done")
                            Image(systemName: "checkmark.circle")
                            Spacer()
                        }
                    }
                }
            }
        }
        .navigationTitle("Settings")
        .navigationBarBackButtonHidden(true) // デフォルトの戻るボタンを非表示
    }
}
