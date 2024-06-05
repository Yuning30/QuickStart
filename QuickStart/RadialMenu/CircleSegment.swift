//
//  CircleSegment.swift
//  QuickStart
//
//  Created by Yuning Wang on 6/3/24.
//

import SwiftUI

struct CircleSegment: View {
    var angle: Double
    var radialMenuSize: CGFloat
    var icon: String
    var color: Color
    var fourParts: Bool
    
    var body: some View {
        DirectionSelectorCircleSegment(angle: .zero, radialMenuSize: radialMenuSize, fourParts: fourParts)
            .stroke(Color.black, lineWidth: 1)
            .fill(color)
            .overlay {
                Image(systemName: icon)
                    .rotationEffect(Angle(degrees: angle))
                    .offset(x: 0.45 * radialMenuSize, y: 0)
            }
            .rotationEffect(Angle(degrees: -1 * angle))
    }
}

#Preview {
    struct Preview: View {
        @State private var angle: Double = 90
        @State private var radialMenuSize: CGFloat = 100
        @State private var icon: String = "square.and.arrow.up.fill"
        @State private var color: Color = .blue
        @State private var fourParts: Bool = true
        
        var body: some View {
            CircleSegment(angle: angle, radialMenuSize: radialMenuSize, icon: icon, color: color, fourParts: fourParts)
            .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 100)
        }
    }

    return Preview()
    
}
