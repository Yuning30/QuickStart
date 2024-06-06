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
    var icon: String
    var angle: Double
    var id = UUID()
}

struct CircleSegmentWithImage: View {
    private var radialMenuSize: CGFloat = 200
    private var radialMenuThickness: CGFloat = Defaults[.radialMenuThickness]
    private var color: Color {
        if Defaults[.useSystemAccentColor] {
            Color.accentColor
        }
        else {
            Defaults[.customAccentColor]
        }
    }
    
    private var selectionColor: Color {
        if Defaults[.useDefaultSelectionColor] {
            Color.secondary
        }
        else {
            Defaults[.customSelectionColor]
        }
    }
    
    @State var currentDirection: ActionDirection = .noAction

    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                ZStack {
                    ZStack {
                        if Defaults[.fourParts] {
                            ForEach(Defaults[.fourSegments]) { seg in
                                CircleSegment(angle: seg.angle, radialMenuSize: radialMenuSize, icon: seg.icon, color: color, fourParts: Defaults[.fourParts])
                            }
                            
                            if currentDirection != .noAction {
                                CircleSegment(angle: currentDirection.toAngle(fourParts: Defaults[.fourParts]), radialMenuSize: radialMenuSize, icon: Defaults[.fourSegments][currentDirection.toIndex(fourParts: Defaults[.fourParts])].icon, color: selectionColor, fourParts: Defaults[.fourParts])
                            }
                        }
                        else {
                            ForEach(Defaults[.eightActions]) { seg in
                                CircleSegment(angle: seg.angle, radialMenuSize: radialMenuSize, icon: seg.icon, color: color, fourParts: Defaults[.fourParts])
                            }
                            
                            if currentDirection != .noAction {
                                CircleSegment(angle: currentDirection.toAngle(fourParts: Defaults[.fourParts]), radialMenuSize: radialMenuSize, icon: Defaults[.eightActions][currentDirection.toIndex(fourParts: Defaults[.fourParts])].icon, color: selectionColor, fourParts: Defaults[.fourParts])
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
