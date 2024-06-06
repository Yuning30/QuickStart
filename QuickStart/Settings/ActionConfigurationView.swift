//
//  ActionConfigurationView.swift
//  QuickStart
//
//  Created by Yuning Wang on 6/4/24.
//

import SwiftUI
import Defaults
import SymbolPicker

struct ActionTypePicker: View {
    @Binding var actiontype: ActionType
    
    var body: some View {
        Picker("Action Type", selection: $actiontype) {
            ForEach(ActionType.allCases) {
                atype in Text(atype.rawValue)
            }
        }
    }
}

struct ActionDetailPicker: View {
    @Binding var icon: String
    @Binding var builtinAction: BuiltinActions
    @Binding var shortcutKeys: Set<CGKeyCode>
    @Binding var scriptURL: URL?
    
    @State private var isPresented = false
    @State private var showFileImporter = false
    
    var actionType: ActionType
    
    var body: some View {
        switch actionType {
        case .builtin:
            Picker("Builtin Actions", selection: $builtinAction) {
                ForEach(BuiltinActions.allCases) {
                    action in Text(action.rawValue)
                }
            }
        case .shortcuts:
            HStack {
                Text("Pick a shortcut")
                Spacer()
                ShortcutKeycorder($shortcutKeys)
            }
        case .application:
            Text("application")
        case .appleScript:
            HStack {
                Text("Select a script")
                Spacer()
                let labelStr = if let url = scriptURL { url.path } else { "No Script Selected" }
                Button(labelStr) {
                    showFileImporter.toggle()
                }
                .fileImporter(
                    isPresented: $showFileImporter,
                    allowedContentTypes: [.appleScript, .osaScript],
                    allowsMultipleSelection: false
                ) { result in
                    switch result {
                    case .success(let urls):
                        scriptURL = urls[0]
                    case .failure(let error):
                        print(error)
                    }
                }
            }
//        default:
//            Text("under construction")
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
}

struct ActionConfigurationView: View {
    @Binding var fourParts: Bool
    @Binding var actionDirection: ActionDirection
    
    var body: some View {
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
//        Picker("Action Type", selection: $fourActions[0].actionType) {
//            ForEach(ActionType.allCases) {
//                atype in Text(atype.rawValue)
//            }
//        }
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
    }
}

//#Preview {
//    ActionConfigurationView()
//}
