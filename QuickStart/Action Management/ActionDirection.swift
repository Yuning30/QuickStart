//
//  WindowDirection.swift
//  Loop
//
//  Created by Kai Azim on 2023-06-14.
//

import SwiftUI
import Defaults

// Enum that stores all possible resizing options
// swiftlint:disable:next type_body_length
enum ActionDirection: String, CaseIterable, Identifiable, Codable {
    var id: Self { self }

    case noAction = "NoAction"

    // General
    case top = "top"
    case topRight = "topRight"
    case right = "right"
    case bottomRight = "bottomRight"
    case bottom = "bottom"
    case bottomLeft = "bottomLeft"
    case left = "left"
    case topLeft = "topLeft"
    
    func toIndex(fourParts: Bool) -> Int {
        if fourParts {
            switch self {
            case .top:
                return 0
            case .right:
                return 1
            case .bottom:
                return 2
            case .left:
                return 3
            default:
                print(self)
                print(fourParts)
                return -1
            }
        }
        else {
            switch self {
            case .top:
                return 0
            case .topRight:
                return 1
            case .right:
                return 2
            case .bottomRight:
                return 3
            case .bottom:
                return 4
            case .bottomLeft:
                return 5
            case .left:
                return 6
            case .topLeft:
                return 7
            default:
                print(self)
                print(fourParts)
                return -1
            }
        }
    }
    
    func toAction(fourParts: Bool) -> SegmentDescription {
        let actionIndex = self.toIndex(fourParts: fourParts)
        if fourParts {
            return Defaults[.fourSegments][actionIndex]
        }
        return Defaults[.eightActions][actionIndex]
    }
    
    func toAngle(fourParts: Bool) -> Double {
        if fourParts {
            switch self {
            case .top:
                return 90
            case .right:
                return 0
            case .bottom:
                return 270
            case .left:
                return 180
            default:
                return -1
            }
        }
        else {
            switch self {
            case .top:
                return 90
            case .topRight:
                return 45
            case .right:
                return 0
            case .bottomRight:
                return 315
            case .bottom:
                return 270
            case .bottomLeft:
                return 225
            case .left:
                return 180
            case .topLeft:
                return 135
            default:
                return -1
            }
        }
    }
}
