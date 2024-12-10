import SwiftUI

struct SettingView: View {
    @State private var draw_rectangle: Bool = false
    @State private var isVibrationOn: Bool = false
    
    var body: some View {
        Form {
            Section(header: Text("View setting")) {
                Toggle("draw rectangle", isOn: $draw_rectangle)
                //Toggle("Vibration", isOn: $isVibrationOn)
            }
            Section(header: Text("Save:")) {
                Button(action: {
                    /*
                    print("Settings Saved: Alarm - \(isAlarmOn), Vibration - \(isVibrationOn)")
                     */
                    print("save was taped")
                })
                {
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
