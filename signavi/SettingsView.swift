import SwiftUI

struct SettingView: View {
    
    //var cameraManager = CameraManager()
    
    @State private var draw_rectangle: Bool = UserDefaults.standard.bool(forKey: "draw_rectangle")
    @State private var screenBrightness: Float = Float(UIScreen.main.brightness)
    @State private var auto_luminus: Bool = UserDefaults.standard.bool(forKey: "auto_luminus")
    @State private var setting_fps_rate: Float = UserDefaults.standard.float(forKey: "setting_fps_rate")
    
    @State private var select_language: String = {
        let savedLanguageCode = UserDefaults.standard.string(forKey: "select_language") ?? "EN"
        return ["日本語": "JP", "English": "EN", "中文": "CN", "한국어": "KR"]
            .first(where: { $0.value == savedLanguageCode })?.key ?? "English"
    }()

    let languages = ["日本語", "English", "中文", "한국어"]
    let languageCodes = ["日本語": "JP", "English": "EN", "中文": "CN", "한국어": "KR"]

    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "arrow.left")
                        Text(localizedText("Back"))
                    }
                    .foregroundColor(.blue)
                }
                Spacer()
            }
            .padding()

            Form {
                Section(header: Text(localizedText("View setting"))) {
                    Toggle(localizedText("Draw Rectangle"), isOn: $draw_rectangle)
                        .onChange(of: draw_rectangle) { newValue in
                            UserDefaults.standard.set(newValue, forKey: "draw_rectangle")
                            print("draw_rectangle was changed to: \(newValue)")
                        }
                }
                
                Section(header: Text(localizedText("Screen Brightness"))) {
                    VStack(alignment: .leading) {
                        Toggle(localizedText("Luminous Auto Setting"), isOn: $auto_luminus)
                            .onChange(of: auto_luminus) { newValue in
                                UserDefaults.standard.set(newValue, forKey: "auto_luminus")
                                print("auto_luminus was changed to: \(newValue)")
                            }
                    }
                }
                
                Section(header: Text(localizedText("Camera FPS Setting"))) {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("\(localizedText("Camera FPS")): \(Int(setting_fps_rate))")
                            
                            Slider(value: $setting_fps_rate, in: 10...30, step: 1)
                                .onChange(of: setting_fps_rate) { newValue in
                                    UserDefaults.standard.set(newValue, forKey: "setting_fps_rate")
                                    print("New FPS value saved: \(newValue)")
                                }
                        }
                    }
                    .padding()
                    .onAppear {
                        setting_fps_rate = UserDefaults.standard.float(forKey: "setting_fps_rate")
                    }
                }
                
                Section(header: Text(localizedText("Language Selection"))) {
                    Picker(localizedText("Select Language"), selection: $select_language) {
                        ForEach(languages, id: \.self) { language in
                            Text(language).tag(language)
                        }
                    }
                    .onChange(of: select_language) { newValue in
                        if let languageCode = languageCodes[newValue] {
                            UserDefaults.standard.set(languageCode, forKey: "select_language")
                            print("Language selected: \(newValue), code: \(languageCode)")
                        }
                    }
                }
            }
        }
        .navigationTitle(localizedText("Settings"))
        .navigationBarBackButtonHidden(true)
    }
    
    /// 言語に応じたテキストを返す関数
    func localizedText(_ key: String) -> String {
        switch select_language {
        case "日本語":
            return [
                "Back": "戻る",
                "View setting": "表示設定",
                "Draw Rectangle": "矩形を描画",
                "Screen Brightness": "画面の明るさ",
                "Luminous Auto Setting": "自動輝度設定",
                "Camera FPS Setting": "カメラFPS設定",
                "Camera FPS": "カメラFPS",
                "Language Selection": "言語選択",
                "Select Language": "言語を選択",
                "Settings": "設定"
            ][key] ?? key
        case "中文":
            return [
                "Back": "返回",
                "View setting": "视图设置",
                "Draw Rectangle": "绘制矩形",
                "Screen Brightness": "屏幕亮度",
                "Luminous Auto Setting": "自动亮度设置",
                "Camera FPS Setting": "相机FPS设置",
                "Camera FPS": "相机FPS",
                "Language Selection": "语言选择",
                "Select Language": "选择语言",
                "Settings": "设置"
            ][key] ?? key
        case "한국어":
            return [
                "Back": "뒤로",
                "View setting": "보기 설정",
                "Draw Rectangle": "사각형 그리기",
                "Screen Brightness": "화면 밝기",
                "Luminous Auto Setting": "자동 밝기 설정",
                "Camera FPS Setting": "카메라 FPS 설정",
                "Camera FPS": "카메라 FPS",
                "Language Selection": "언어 선택",
                "Select Language": "언어 선택",
                "Settings": "설정"
            ][key] ?? key
        default:
            return key
        }
    }
}
