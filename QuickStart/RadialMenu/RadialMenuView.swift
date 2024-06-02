//
//  RadialMenuView.swift
//  Loop
//
//  Created by Kai Azim on 2023-01-24.
//

import SwiftUI
import Combine
import Defaults

struct RadialMenuView: View {
    let radialMenuSize: CGFloat = 100
    var radialMenuCornerRadius: CGFloat = 50
    var radialMenuThickness: CGFloat = 22
    
    @State var angle: Double = .zero

    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()

                ZStack {
                    ZStack {
                        // NSVisualEffect on background

                        // This rectangle with a gradient is masked with the current direction radial menu view
                        Rectangle()
                            .mask {
                                Color.clear
                                    .overlay {
                                        ZStack {
                                            ZStack {
                                                if radialMenuCornerRadius >= radialMenuSize / 2 - 2 {
                                                    DirectionSelectorCircleSegment(
                                                        angle: self.angle,
                                                        radialMenuSize: self.radialMenuSize
                                                    )
                                                } else {
                                                    DirectionSelectorSquareSegment(
                                                        angle: self.angle,
                                                        radialMenuCornerRadius: self.radialMenuCornerRadius,
                                                        radialMenuThickness: self.radialMenuThickness
                                                    )
                                                }
                                            }
                                            .compositingGroup()
                                        }
                                    }
                            }

                        if radialMenuCornerRadius >= radialMenuSize / 2 - 2 {
                            Circle()
                                .stroke(.quinary, lineWidth: 2)

                            Circle()
                                .stroke(.quinary, lineWidth: 2)
                                .padding(self.radialMenuThickness)
                        } else {
                            RoundedRectangle(cornerRadius: radialMenuCornerRadius, style: .continuous)
                                .stroke(.quinary, lineWidth: 2)

                            RoundedRectangle(
                                cornerRadius: radialMenuCornerRadius - self.radialMenuThickness,
                                style: .continuous
                            )
                            .stroke(.quinary, lineWidth: 2)
                            .padding(self.radialMenuThickness)
                        }
                    }
                    // Mask the whole ZStack with the shape the user defines
                    .mask {
                        if radialMenuCornerRadius >= radialMenuSize / 2 - 2 {
                            Circle()
                                .strokeBorder(.black, lineWidth: radialMenuThickness)
                        } else {
                            RoundedRectangle(cornerRadius: radialMenuCornerRadius, style: .continuous)
                                .strokeBorder(.black, lineWidth: radialMenuThickness)
                        }
                    }
                }
                .frame(width: radialMenuSize, height: radialMenuSize)

                Spacer()
            }
            Spacer()
        }
        .shadow(radius: 10)

        // Animate window
        
    }
}

#Preview {
    RadialMenuView()
}
