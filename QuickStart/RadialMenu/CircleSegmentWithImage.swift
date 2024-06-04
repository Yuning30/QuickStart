//
//  CircleSegmentWithImage.swift
//  QuickStart
//
//  Created by Yuning Wang on 6/3/24.
//

import SwiftUI

struct SegmentDescription: Identifiable {
    var imageName: String
    var angle: Double
    let id = UUID()
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
                            CircleSegment(angle: seg.angle, radialMenuSize: radialMenuSize, imageName: seg.imageName, color: .blue)
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
    CircleSegmentWithImage(segments: [SegmentDescription(imageName: "square.and.arrow.up.fill", angle: 0), SegmentDescription(imageName: "playpause.circle", angle: 45), SegmentDescription(imageName: "circle.square", angle: 90)])
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
