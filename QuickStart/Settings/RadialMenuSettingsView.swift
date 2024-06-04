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
    @Default(.radialMenuVisibility) var radialMenuVisibility
    @Default(.radialMenuCornerRadius) var radialMenuCornerRadius
    @Default(.radialMenuThickness) var radialMenuThickness
    @Default(.disableCursorInteraction) var disableCursorInteraction
    @Default(.fourParts) var fourParts
    @Default(.eightActions) var eightActions
    @Default(.fourActions) var fourActions
    
    @State private var actionDirection: ActionDirection = .top
    @State private var icon = "star.fill"
    @State private var isPresented = false
    
    var body: some View {
        Form {
            Section("Appearance") {
                Toggle("Show radial menu when looping", isOn: $radialMenuVisibility)

                Toggle("Disable cursor interaction", isOn: $disableCursorInteraction)
                    .disabled(!radialMenuVisibility)
                    .foregroundColor(!radialMenuVisibility ? .secondary : nil)
                
                Toggle("Using 4 directions", isOn: $fourParts)
            }

            Section("Preview") {
                ZStack {
//                    VisualEffectView(material: .sidebar, blendingMode: .behindWindow)
//                        .ignoresSafeArea()
//                        .padding(-10)
                    if fourParts {
                        CircleSegmentWithImage(segments: fourActions)
                    }
                    else {
                        CircleSegmentWithImage(segments: eightActions)
                    }
                }
            }
            .opacity(radialMenuVisibility ? 1 : 0.5)

            Section("Action Configuration") {
                Picker("Action Direction", selection: $actionDirection) {
                    if fourParts {
                        Text(ActionDirection.top.rawValue)
                        Text(ActionDirection.right.rawValue)
                        Text(ActionDirection.left.rawValue)
                        Text(ActionDirection.bottom.rawValue)
                    }
                    else {
                        ForEach(ActionDirection.allCases) {
                            direction in Text(direction.rawValue)
                        }
                    }
                }
                Picker("Action Type", selection: $eightActions[0].actionType) {
                    ForEach(ActionType.allCases) {
                        atype in Text(atype.rawValue)
                    }
                }
            
                
                switch fourActions[0].actionType {
                case .builtin:
                    Picker("Builtin Actions", selection: $eightActions[0].builtinAction) {
                        ForEach(BuiltinActions.allCases) {
                            action in Text(action.rawValue)
                        }
                    }
                    
                default:
                    Text("under construction")
                }
                
                HStack {
                    Text("Select a symbol")
                    Spacer()
                    Image(systemName: icon).sheet(isPresented: $isPresented, content: {
                        SymbolPicker(symbol: $icon)
                    })
                    Button("Select a symbol") {
                        isPresented.toggle()
                    }
                }
            }
            .disabled(!radialMenuVisibility)
            .foregroundColor(!radialMenuVisibility ? .secondary : nil)
            
            
//            Section {
//                VStack {
//                    Button("Select a symbol") {
//                        isPresented.toggle()
//                    }
//                        ..padding()
//
//                }
//            }
        }
        .formStyle(.grouped)
        .scrollDisabled(true)
    }
}
