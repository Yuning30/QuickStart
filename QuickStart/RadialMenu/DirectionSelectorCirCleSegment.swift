//
//  DirectionSelectorCircleSegment.swift
//  Loop
//
//  Created by Kai Azim on 2023-08-19.
//

import SwiftUI
import Defaults

struct DirectionSelectorCircleSegment: Shape {
    var angle: Double
    var radialMenuSize: CGFloat
    var fourParts: Bool
    
    func angleOffset() -> Double {
        let numParts: Double = if fourParts { 4 } else { 8 }
        return 360 / 2 / Double(numParts)
    }

    var animatableData: Double {
        get { self.angle }
        set { self.angle = newValue }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(
            to: CGPoint(
                x: radialMenuSize/2,
                y: radialMenuSize/2
            )
        )
        path.addArc(
            center: CGPoint(
                x: radialMenuSize/2,
                y: radialMenuSize/2
            ),
            radius: radialMenuSize/2,
            startAngle: .degrees(angle - angleOffset()),
            endAngle: .degrees(angle + angleOffset()),
            clockwise: false
        )
        path.addLine(
            to: CGPoint(
                x: radialMenuSize/2,
                y: radialMenuSize/2
            )
        )

        return path
    }
}
