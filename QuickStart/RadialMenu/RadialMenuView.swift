//
//  RadialMenuView.swift
//  Loop
//
//  Created by Kai Azim on 2023-01-24.
//

import SwiftUI
import Combine
import Defaults
import UserNotifications

struct RadialMenuView: View {
    @State private var radialMenuSize: CGFloat = 100
    var radialMenuCornerRadius: CGFloat = 50
    var radialMenuThickness: CGFloat = 22
    var previewMode = false
    @State var angle: Double = .zero
    @State var currentAction: ActionDirection = .noAction
    @State var previousAction: ActionDirection?
    @State private var fourParts: Bool

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
                                                    DirectionSelectorCircleSegment(
                                                        angle: angle,
                                                        radialMenuSize: radialMenuSize,
                                                        fourParts: fourParts
                                                    )
                                            }
                                            .compositingGroup()
                                        }
                                    }
                            }
                        
                            Circle()
                                .stroke(.quinary, lineWidth: 2)

                            Circle()
                                .stroke(.quinary, lineWidth: 2)
                                .padding(self.radialMenuThickness)
                    }
                    // Mask the whole ZStack with the shape the user defines
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
        .scaleEffect(currentAction == .noAction ? 0.85 : 1)
        .animation(.easeOut(duration: 0.2), value: currentAction)
        .onAppear {
            if previewMode {
                currentAction = currentAction
            }
        }
        
        // Animate window
        .onReceive(Notification.Name.updateUIDirection) { 
            obj in
            if !self.previewMode, let action = obj.userInfo?["action"] as? ActionDirection {
                self.previousAction = self.currentAction
                self.currentAction = action

                print("New radial menu window action received: \(action)")
            }
        }
        .onChange(of: self.currentAction) { _ in
            switch self.currentAction {
            case .noAction:
                self.angle = 0
            case .right:
                self.angle = 0
            case .bottomRight:
                self.angle = 45
            case .bottom:
                self.angle = 90
            case .bottomLeft:
                self.angle = 135
            case .left:
                self.angle = 180
            case .topLeft:
                self.angle = 225
            case .top:
                self.angle = 270
            case .topRight:
                self.angle = 315
            }
//            if let target = self.currentAction.radialMenuAngle(window: window) {
//                let closestAngle: Angle = .degrees(self.angle).angleDifference(to: target)
//
//                let previousActionHadAngle = self.previousAction?.direction.hasRadialMenuAngle ?? false
//                let animate: Bool = abs(closestAngle.degrees) < 179 && previousActionHadAngle
//
//                let defaultAnimation = AnimationConfiguration.fast.radialMenuAngle
//                let noAnimation = Animation.linear(duration: 0)
//
//                withAnimation(animate ? defaultAnimation : noAnimation) {
//                    self.angle += closestAngle.degrees
//                }
//            }
        }
    }
}

//#Preview {
//    RadialMenuView()
//}
