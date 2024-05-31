//
//  DirectionSelectorSquareSegment.swift
//  Loop
//
//  Created by Kai Azim on 2023-08-19.
//

import SwiftUI

struct DirectionSelectorSquareSegment: View {
    var angle: Double = .zero
    let radialMenuCornerRadius: CGFloat
    let radialMenuThickness: CGFloat

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: radialMenuCornerRadius, style: .continuous)
                .trim(
                    from: (Angle(degrees: self.angle - 22.5).normalized().degrees / 360.0),
                    to: (Angle(degrees: self.angle + 22.5).normalized().degrees / 360.0)
                )
                .stroke(.white, lineWidth: radialMenuThickness * 2)

            RoundedRectangle(cornerRadius: radialMenuCornerRadius, style: .continuous)
                .trim(
                    from: (Angle(degrees: self.angle - 180 - 22.5).normalized().degrees / 360.0),
                    to: (Angle(degrees: self.angle - 180 + 22.5).normalized().degrees / 360.0)
                )
                .stroke(.white, lineWidth: radialMenuThickness * 2)
                .rotationEffect(.degrees(180))
        }
    }
}



#Preview {
    DirectionSelectorSquareSegment(radialMenuCornerRadius: 10, radialMenuThickness: 10)
}
