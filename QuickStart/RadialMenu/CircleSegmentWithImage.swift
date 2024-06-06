//
//  CircleSegmentWithImage.swift
//  QuickStart
//
//  Created by Yuning Wang on 6/3/24.
//

import SwiftUI
import Defaults

enum ActionType: String, Codable, CaseIterable, Identifiable, Defaults.Serializable {
    var id: Self { self }
    
    case builtin = "Builtin"
    case shortcuts = "Shortcuts"
    case application = "Start App"
    case appleScript = "Run AppleScript"
}

enum BuiltinActions: String, Identifiable, CaseIterable, Codable, Defaults.Serializable {
    var id: Self { self }
    
    case startPause = "Start/Pause"
    case next = "Next"
    case previous = "Previous"
}

struct SegmentDescription: Codable, Identifiable, Hashable, Equatable, Defaults.Serializable {
    var actionType: ActionType = .builtin
    var builtinAction: BuiltinActions = .startPause
    var shortcutKeys: Set<CGKeyCode> = [.kVK_F1]
    var scriptURL: URL? = nil
    var icon: String
    var angle: Double
    var id = UUID()
}

struct CircleSegmentWithImage: View {
    private var radialMenuSize: CGFloat = 200
    private var radialMenuThickness: CGFloat = Defaults[.radialMenuThickness]
    
    @Default(.useSystemAccentColor) var useSystemAccentColor
    @Default(.customAccentColor) var customAccentColor
    @Default(.useDefaultSelectionColor) var useDefaultSelectionColor
    @Default(.customSelectionColor) var customSelectionColor
    @Default(.fourParts) var fourParts
    @Default(.fourSegments) var fourSegments
    @Default(.eightActions) var eightActions
//    @State private var color: Color {
//        if Defaults[.useSystemAccentColor] {
//            Color.accentColor
//        }
//        else {
//            Defaults[.customAccentColor]
//        }
//    }
//    
//    private var selectionColor: Color {
//        if Defaults[.useDefaultSelectionColor] {
//            Color.secondary
//        }
//        else {
//            Defaults[.customSelectionColor]
//        }
//    }
    
    @State var currentDirection: ActionDirection = .noAction

    var body: some View {
        var color: Color {
            if useSystemAccentColor {
                Color.accentColor
            }
            else {
                customAccentColor
            }
        }
        
        var selectionColor: Color {
            if useDefaultSelectionColor {
                Color.secondary
            }
            else {
                customSelectionColor
            }
        }

        VStack {
            Spacer()
            HStack {
                Spacer()
                ZStack {
                    ZStack {
                        if fourParts {
                            ForEach(fourSegments) { seg in
                                CircleSegment(angle: seg.angle, radialMenuSize: radialMenuSize, icon: seg.icon, color: color, fourParts: fourParts)
                            }
                            
                            if currentDirection != .noAction {
                                CircleSegment(angle: currentDirection.toAngle(fourParts: fourParts), radialMenuSize: radialMenuSize, icon: fourSegments[currentDirection.toIndex(fourParts: fourParts)].icon, color: selectionColor, fourParts: fourParts)
                            }
                        }
                        else {
                            ForEach(eightActions) { seg in
                                CircleSegment(angle: seg.angle, radialMenuSize: radialMenuSize, icon: seg.icon, color: color, fourParts: fourParts)
                            }
                            
                            if currentDirection != .noAction {
                                CircleSegment(angle: currentDirection.toAngle(fourParts: fourParts), radialMenuSize: radialMenuSize, icon: eightActions[currentDirection.toIndex(fourParts: fourParts)].icon, color: selectionColor, fourParts: fourParts)
                            }
                        }
                        
                        Circle()
                            .stroke(.quinary, lineWidth: 2)

                        Circle()
                            .stroke(.quinary, lineWidth: 2)
                            .padding(radialMenuThickness)
                    }
                    .mask {
                        Circle()
                            .strokeBorder(.black, lineWidth: radialMenuThickness)
                    }
                }
                .frame(width: radialMenuSize, height: radialMenuSize)
                Spacer()
            }
            Spacer()
        }
        .shadow(radius: 10)
        .onReceive(Notification.Name.updateUIDirection) {
            obj in
            if let action = obj.userInfo?["action"] as? ActionDirection {
                self.currentDirection = action

                print("New radial menu window action received: \(action)")
            }
        }
    }
}

#Preview {
    struct Preview: View {
        var body: some View {
            CircleSegmentWithImage()
        }
    }

    return Preview()
    
    
}

#Preview {
    Circle()
        .strokeBorder(.black, lineWidth: 44)
}

#Preview {
    ZStack {
        Circle()
            .stroke(.quinary, lineWidth: 2)
        Circle()
            .stroke(.quinary, lineWidth: 2)
            .padding(44)
    }
}
