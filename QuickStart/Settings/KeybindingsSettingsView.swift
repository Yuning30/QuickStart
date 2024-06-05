//
//  KeybindingsSettingsView.swift
//  Loop
//
//  Created by Kai Azim on 2023-10-28.
//

import SwiftUI
import Defaults

struct KeybindingsSettingsView: View {
//    @Default(.keybinds) var keybinds
    @Default(.useSystemAccentColor) var useSystemAccentColor
    @Default(.customAccentColor) var customAccentColor

    @Default(.triggerKey) var triggerKey
    @Default(.doubleClickToTrigger) var doubleClickToTrigger
    @Default(.triggerDelay) var triggerDelay
    @Default(.middleClickTriggersLoop) var middleClickTriggersLoop

    @StateObject private var keycorderModel = KeycorderModel()
    @State private var suggestAddingTriggerDelay: Bool = false
//    @State private var selection = Set<WindowAction>()

    var body: some View {
        ZStack {
            Form {
                Section("Trigger Key") {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Trigger key")
                            Spacer()
                            TriggerKeycorder(self.$triggerKey)
                        }

                        if triggerKey == [.kVK_RightControl] {
                            Text("Tip: To use Caps Lock, remap it to control in System Settings!")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }

                    CrispValueAdjuster(
                        .init(localized: .init("Crisp Value Adjuster: Trigger Delay", defaultValue: "Trigger delay")),
                        value: $triggerDelay,
                        sliderRange: 0...1,
                        postscript: .init(localized: .init("sec", defaultValue: "sec")),
                        step: 0.1,
                        lowerClamp: true
                    )

                    Toggle("Double-click trigger key to trigger \(Bundle.main.appName)", isOn: $doubleClickToTrigger)
                    Toggle("Middle-click to trigger \(Bundle.main.appName)", isOn: $middleClickTriggersLoop)
                }
            }
            .formStyle(.grouped)
        }
        .environmentObject(keycorderModel)
    }
}
