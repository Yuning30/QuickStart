//
//  GeneralSettingsView.swift
//  Loop
//
//  Created by Kai Azim on 2023-01-24.
//

import SwiftUI
import Defaults
import ServiceManagement

struct GeneralSettingsView: View {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    @Default(.launchAtLogin) var launchAtLogin
    @Default(.hideMenuBarIcon) var hideMenuBarIcon
    @Default(.useSystemAccentColor) var useSystemAccentColor
    @Default(.customAccentColor) var customAccentColor
    @Default(.useGradient) var useGradient
    @Default(.gradientColor) var gradientColor
    @Default(.currentIcon) var currentIcon
    @Default(.notificationWhenIconUnlocked) var notificationWhenIconUnlocked
    @Default(.timesLooped) var timesLooped
//    @Default(.padding) var padding
    @Default(.windowSnapping) var windowSnapping
//    @Default(.animationConfiguration) var animationConfiguration
    @Default(.restoreWindowFrameOnDrag) var restoreWindowFrameOnDrag
    @Default(.resizeWindowUnderCursor) var resizeWindowUnderCursor
    @Default(.focusWindowOnResize) var focusWindowOnResize

    @State var userDisabledLoopNotifications: Bool = false
    @State var iconFooter: String?

    @State var isConfiguringPadding: Bool = false

    var body: some View {
        Form {
            Section("Behavior") {
                Toggle("Launch at login", isOn: $launchAtLogin)
                    .onChange(of: launchAtLogin) {
                        if launchAtLogin {
                            try? SMAppService().register()
                        } else {
                            try? SMAppService().unregister()
                        }
                    }

                VStack(alignment: .leading) {
                    Toggle("Hide menubar icon", isOn: $hideMenuBarIcon)

                    if hideMenuBarIcon {
                        Text("Re-open \(Bundle.main.appName) to see this window.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .textSelection(.enabled)
                    }
                }
            }

            Section("Accent Color") {
                Toggle("Use system accent color", isOn: $useSystemAccentColor)

                if !useSystemAccentColor {
                    ColorPicker("Custom accent color", selection: $customAccentColor, supportsOpacity: false)
                }

                Toggle("Use gradient", isOn: $useGradient)

                if !useSystemAccentColor && useGradient {
                    ColorPicker("Custom gradient color", selection: $gradientColor, supportsOpacity: false)
                        .foregroundColor(
                            useGradient ? (useSystemAccentColor ? .secondary : nil) : .secondary
                        )
                }
            }
        }
        .formStyle(.grouped)
        .scrollDisabled(true)
    }
}
