import SwiftUI

struct SettingView: View {
    @State private var draw_rectangle: Bool = UserDefaults.standard.bool(forKey: "draw_rectangle")
    @State private var isVibrationOn: Bool = UserDefaults.standard.bool(forKey: "isVibrationOn")
    
    // PresentationModeを使ってビューを閉じる
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Form {
            Section(header: Text("View setting")) {
                Toggle("draw rectangle", isOn: $draw_rectangle)
                // Toggle("Vibration", isOn: $isVibrationOn)
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
        .navigationTitle("Settings")
    }
}
