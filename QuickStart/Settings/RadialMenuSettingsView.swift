//
//  RadialMenuSettingsView.swift
//  Loop
//
//  Created by Kai Azim on 2023-01-25.
//

import SwiftUI
import Defaults
import SymbolPicker

struct RadialMenuSettingsView: View {
    @Default(.radialMenuCornerRadius) var radialMenuCornerRadius
    @Default(.radialMenuThickness) var radialMenuThickness
    @Default(.disableCursorInteraction) var disableCursorInteraction
    @Default(.fourParts) var fourParts
    @Default(.eightActions) var eightActions
    @Default(.fourSegments) var fourSegments
    
    @State private var actionDirection: ActionDirection = .top
    @State private var icon = "star.fill"
    @State private var isPresented = false
    @StateObject private var keycorderModel = KeycorderModel()
    
    var body: some View {
        Form {
            Section("Appearance") {
                Toggle("Using 4 directions", isOn: $fourParts)

                Toggle("Disable cursor interaction", isOn: $disableCursorInteraction)
            }

            Section("Preview") {
                ZStack {
//                    VisualEffectView(material: .sidebar, blendingMode: .behindWindow)
//                        .ignoresSafeArea()
//                        .padding(-10)
                    if fourParts {
                        CircleSegmentWithImage()
                    }
                    else {
                        CircleSegmentWithImage()
                    }
                }
            }

            Section("Action Configuration") {
                Picker("Action Direction", selection: $actionDirection) {
                    if fourParts {
                        Text(ActionDirection.top.rawValue).tag(ActionDirection.top)
                        Text(ActionDirection.right.rawValue).tag(ActionDirection.right)
                        Text(ActionDirection.left.rawValue).tag(ActionDirection.left)
                        Text(ActionDirection.bottom.rawValue).tag(ActionDirection.bottom)
                    }
                    else {
                        ForEach(ActionDirection.allCases) {
                            direction in Text(direction.rawValue).tag(direction)
                        }
                    }
                }
                
                let segIndex = actionDirection.toIndex(fourParts: fourParts)
                
                if fourParts {
                    ActionTypePicker(actiontype: $fourSegments[segIndex].actionType)
                }
                else {
                    ActionTypePicker(actiontype: $eightActions[segIndex].actionType)
                }

            
                if fourParts {
                    ActionDetailPicker(icon: $fourSegments[segIndex].icon, builtinAction: $fourSegments[segIndex].builtinAction, shortcutKeys: $fourSegments[segIndex].shortcutKeys, scriptURL: $fourSegments[segIndex].scriptURL, appName: $fourSegments[segIndex].appName, appInstallationPath: $fourSegments[segIndex].appInstallationPath, actionType: fourSegments[segIndex].actionType)
                }
                else {
                    ActionDetailPicker(icon: $eightActions[segIndex].icon, builtinAction: $eightActions[segIndex].builtinAction, shortcutKeys: $eightActions[segIndex].shortcutKeys, scriptURL: $eightActions[segIndex].scriptURL, appName: $eightActions[segIndex].appName, appInstallationPath: $eightActions[segIndex].appInstallationPath, actionType: eightActions[segIndex].actionType)
                }

            }
        }
        .environmentObject(keycorderModel)
        .formStyle(.grouped)
        .scrollDisabled(true)
    }
}
