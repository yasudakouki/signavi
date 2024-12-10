import SwiftUI

struct SettingView: View {
    @State private var isAlarmOn: Bool = false
    @State private var isVibrationOn: Bool = false
    
    var body: some View {
        Form {
            Section(header: Text("Alarm:")) {
                Toggle("Alarm Sound", isOn: $isAlarmOn)
                Toggle("Vibration", isOn: $isVibrationOn)
            }
            Section(header: Text("Save:")) {
                Button(action: {
                    print("Settings Saved: Alarm - \(isAlarmOn), Vibration - \(isVibrationOn)")
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
