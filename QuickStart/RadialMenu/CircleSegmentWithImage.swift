//
//  CircleSegmentWithImage.swift
//  QuickStart
//
//  Created by Yuning Wang on 6/3/24.
//

import SwiftUI
import Defaults

enum ActionType: String, Codable, CaseIterable, Identifiable {
    var id: Self { self }
    
    case builtin = "Builtin"
    case shortcuts = "Shortcuts"
    case application = "Start App"
    case appleScript = "Run AppleScript"
}

enum BuiltinActions: String, Identifiable, CaseIterable, Codable {
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
    let radialMenuSize: CGFloat = 200
    let radialMenuThickness: CGFloat = 22
    let segments: [SegmentDescription]

    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                ZStack {
                    ZStack {
                        ForEach(segments) { seg in
                            CircleSegment(angle: seg.angle, radialMenuSize: radialMenuSize, icon: seg.icon, color: .blue)
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
    }
}

#Preview {
    CircleSegmentWithImage(segments: [SegmentDescription(icon: "square.and.arrow.up.fill", angle: 0), SegmentDescription(icon: "playpause.circle", angle: 45), SegmentDescription(icon: "circle.square", angle: 90)])
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
