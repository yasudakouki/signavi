import SwiftUI

struct SettingView: View {
    
    var cameraManager = CameraManager()
    
    @State private var draw_rectangle: Bool = UserDefaults.standard.bool(forKey: "draw_rectangle")
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
                    Toggle("Draw Rectangle", isOn: $draw_rectangle)
                        .onChange(of: draw_rectangle) { newValue in
                            UserDefaults.standard.set(newValue, forKey: "draw_rectangle")
                            print("draw_rectangle was changed to: \(newValue)")
                        }
                }
                
                Section(header: Text("Screen Brightness")) {
                    VStack(alignment: .leading) {
                        Toggle("Luminous Auto Setting", isOn: $auto_luminus)
                            .onChange(of: auto_luminus) { newValue in
                                UserDefaults.standard.set(newValue, forKey: "auto_luminus")
                                print("auto_luminus was changed to: \(newValue)")
                            }
                    }
                }
                
                Section(header: Text("Camera FPS Setting")) {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Camera FPS: \(Int(setting_fps_rate))") // FPSの値を表示
                            
                            Slider(value: $setting_fps_rate, in: 10...30, step: 1)
                                .onChange(of: setting_fps_rate) { newValue in
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
            }
        }
        .navigationTitle("Settings")
        .navigationBarBackButtonHidden(true) // デフォルトの戻るボタンを非表示
    }
}
