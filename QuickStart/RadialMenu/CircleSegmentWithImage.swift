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

struct FourSegments: Codable, Defaults.Serializable {
    var topSegment: SegmentDescription
    var leftSegment: SegmentDescription
    var rightSegment: SegmentDescription
    var bottomSegment: SegmentDescription
}

struct CircleSegmentWithImage: View {
    private var radialMenuSize: CGFloat = 200
    private var radialMenuThickness: CGFloat = Defaults[.radialMenuThickness]
    private var color: Color = .blue

    var eightSegments = Defaults[.eightActions]
    var fourSegments = Defaults[.fourSegments]
    var fourParts = Defaults[.fourParts]

    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                ZStack {
                    ZStack {
                        if fourParts {
                            ForEach(Defaults[.fourSegments]) { seg in
                                CircleSegment(angle: seg.angle, radialMenuSize: radialMenuSize, icon: seg.icon, color: color, fourParts: fourParts)
                            }
                        }
                        else {
                            ForEach(eightSegments) { seg in
                                CircleSegment(angle: seg.angle, radialMenuSize: radialMenuSize, icon: seg.icon, color: color, fourParts: fourParts)
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
