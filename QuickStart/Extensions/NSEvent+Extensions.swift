//
//  NSEvent+Extensions.swift
//  Loop
//
//  Created by Kai Azim on 2024-03-17.
//

import SwiftUI

extension NSEvent.ModifierFlags {
    var wasKeyUp: Bool {
        self.rawValue == 256 || self.rawValue == 65792
    }
}
