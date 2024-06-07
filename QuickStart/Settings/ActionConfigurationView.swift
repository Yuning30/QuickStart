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
    @Binding var appName: String?
    @Binding var appInstallationPath: String?
    
    @State private var isPresented = false
    @State private var showFileImporter = false
    @State private var appImage: NSImage? = nil
    
    @EnvironmentObject var appListManager: AppListManager
    
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
            HStack {
                
                Text("Select a app")
                Spacer()
                Menu(
                    content: { installedAppsMenu() },
                    label: { 
                        if appImage == nil {
                            Image(systemName: "nosign.app.fill")
                        }
                        else {
                            Image(nsImage: appImage!)
                        }
                        Text(appName ?? "No app selected") }
                )
            }
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
    
    @ViewBuilder
    func installedAppsMenu() -> some View {
        let apps = appListManager.installedApps
            .grouped {
                $0.installationFolder
            }
        let installationFolders = apps.keys.sorted {
            $0.localizedCaseInsensitiveCompare($1) == .orderedAscending
        }

        ForEach(installationFolders, id: \.self) { folder in
            Section(folder) {
                let appsInFolder = apps[folder]!.sorted {
                    $0.displayName.localizedCaseInsensitiveCompare($1.displayName) == .orderedAscending
                }
                ForEach(appsInFolder) { app in
                    Button(action: {
                        appImage = app.icon.resized(to: NSSize(width: 16.0, height: 16.0))
                        appName = app.displayName
                        appInstallationPath = app.installationPath
                    }, label: {
                        // Resizing the image with SwiftUI did not work.  Therefore we change the size of the NSImage.
                        Image(nsImage: app.icon.resized(to: NSSize(width: 16.0, height: 16.0)))
                        Text(app.displayName)
                    })
                }
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
