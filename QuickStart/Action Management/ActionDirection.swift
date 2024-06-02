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
}
