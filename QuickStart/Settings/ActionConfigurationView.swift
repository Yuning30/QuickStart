//
//  ActionConfigurationView.swift
//  QuickStart
//
//  Created by Yuning Wang on 6/4/24.
//

import SwiftUI

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
