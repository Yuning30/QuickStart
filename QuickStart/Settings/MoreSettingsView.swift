//
//  MoreSettingsView.swift
//  Loop
//
//  Created by Kai Azim on 2023-01-28.
//

import SwiftUI
import Sparkle
import Defaults

struct MoreSettingsView: View {
    @Environment(\.openURL) private var openURL
    @EnvironmentObject var updater: SoftwareUpdater

    @Default(.respectStageManager) var respectStageManager
    @Default(.stageStripSize) var stageStripSize
    @Default(.hapticFeedback) var hapticFeedback
    @Default(.hideUntilDirectionIsChosen) var hideUntilDirectionIsChosen
    @Default(.sizeIncrement) var sizeIncrement
    @Default(.animateWindowResizes) var animateWindowResizes
    @Default(.includeDevelopmentVersions) var includeDevelopmentVersions
    @State var isAccessibilityAccessGranted = false

    var body: some View {
        Form {
            Section(content: {
                Toggle("Automatically check for updates", isOn: $updater.automaticallyChecksForUpdates)
                Toggle("Include development versions", isOn: $includeDevelopmentVersions)
            }, header: {
                HStack {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Updates")
                        Button(action: {
                            let pasteboard = NSPasteboard.general
                            pasteboard.clearContents()
                            pasteboard.setString(
                                "Version \(Bundle.main.appVersion) (\(Bundle.main.appBuild))",
                                forType: NSPasteboard.PasteboardType.string
                            )
                        }, label: {
                            let versionText = String(
                                localized: "Current version: \(Bundle.main.appVersion) (\(Bundle.main.appBuild))"
                            )
                            HStack {
                                Text("\(versionText) \(Image(systemName: "doc.on.clipboard"))")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        })
                        .buttonStyle(.plain)
                    }

                    Spacer()

                    Button("Check for Updates…") {
                        updater.checkForUpdates()
                    }
                    .buttonStyle(.link)
                    .foregroundStyle(Color.accentColor)
                }
            })

            Section("Advanced") {
                Toggle("Hide menu until direction is chosen", isOn: $hideUntilDirectionIsChosen)

                Toggle("Haptic feedback", isOn: $hapticFeedback)

            }

            Section(content: {
                HStack {
                    Text("Accessibility access")
                    Spacer()
                    Text(
                        isAccessibilityAccessGranted
                        ? .init(localized: .init("Granted", defaultValue: "Granted"))
                        : .init(localized: .init("Not granted", defaultValue: "Not granted"))
                    )
                    Circle()
                        .frame(width: 8, height: 8)
                        .padding(.trailing, 5)
                        .foregroundColor(isAccessibilityAccessGranted ? .green : .red)
                        .shadow(color: isAccessibilityAccessGranted ? .green : .red, radius: 8)
                }
            }, header: {
                HStack {
                    Text("Permissions")

                    Spacer()

                    Button("Request Access…") {
                        AccessibilityManager.requestAccess()
                        self.isAccessibilityAccessGranted = AccessibilityManager.getStatus()
                    }
                    .buttonStyle(.link)
                    .foregroundStyle(Color.accentColor)
                    .disabled(isAccessibilityAccessGranted)
                    .opacity(isAccessibilityAccessGranted ? 0.6 : 1)
                    .onAppear {
                        self.isAccessibilityAccessGranted = AccessibilityManager.getStatus()
                    }
                }
            })

            Section("Feedback") {
                HStack {
                    Text("""
Sending feedback will bring you to our \"New Issue\" GitHub page, where you can report a bug, request a feature & more!
""")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                    Spacer()

                    Button(action: {
                        openURL(URL(string: "https://github.com/Yuning30/QuickStart/issues/new")!)
                    }, label: {
                        Text("Send Feedback")
                    })
                    .controlSize(.large)
                }
            }
        }
        .formStyle(.grouped)
        .scrollDisabled(true)
    }
}
