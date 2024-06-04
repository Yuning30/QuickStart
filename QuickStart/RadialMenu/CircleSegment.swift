//
//  CircleSegment.swift
//  QuickStart
//
//  Created by Yuning Wang on 6/3/24.
//

import SwiftUI

struct CircleSegment: View {
    let angle: Double
    let radialMenuSize: CGFloat
    let imageName: String
    let color: Color
    
    var body: some View {
        DirectionSelectorCircleSegment(angle: .zero, radialMenuSize: radialMenuSize)
            .stroke(Color.black, lineWidth: 1)
            .fill(color)
            .overlay {
                Image(systemName: imageName)
                    .rotationEffect(Angle(degrees: angle))
                    .offset(x: 0.45 * radialMenuSize, y: 0)
            }
            .rotationEffect(Angle(degrees: -1 * angle))
    }
}

#Preview {
    CircleSegment(angle: 90, radialMenuSize: 100, imageName: "square.and.arrow.up.fill",
                  color: .blue).frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 100)
}
