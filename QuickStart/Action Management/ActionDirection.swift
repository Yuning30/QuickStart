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
    
    func to_index(fourParts: Bool) -> Int {
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
}
