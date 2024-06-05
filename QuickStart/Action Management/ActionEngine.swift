//
//  ActionEngine.swift
//  QuickStart
//
//  Created by Yuning Wang on 6/2/24.
//

import Foundation
import SwiftUI
import Defaults

class ActionEngine {
    static func executeAction(direction: ActionDirection) {
        var action = direction.toAction(fourParts: Defaults[.fourParts])
        
        switch action.actionType {
        case .builtin:
            executeBuiltinAction(action: action.builtinAction)
        default:
            print("under construction")
        }
    }
    
    static func executeBuiltinAction(action: BuiltinActions) {
        switch action {
        case .startPause:
            print("start/pause")
            HIDPostAuxKey(key: 16)
        case .next:
            print("next")
            HIDPostAuxKey(key: 17)
        case .previous:
            print("previous")
            HIDPostAuxKey(key: 18)

        }
    }
    
    static func HIDPostAuxKey(key: UInt32) {
        func doKey(down: Bool) {
            let flags = NSEvent.ModifierFlags(rawValue: (down ? 0xa00 : 0xb00))
            let data1 = Int((key<<16) | (down ? 0xa00 : 0xb00))

            let ev = NSEvent.otherEvent(with: NSEvent.EventType.systemDefined,
                                        location: NSPoint(x:0,y:0),
                                        modifierFlags: flags,
                                        timestamp: 0,
                                        windowNumber: 0,
                                        context: nil,
                                        subtype: 8,
                                        data1: data1,
                                        data2: -1
                                        )
            let cev = ev?.cgEvent
            cev?.post(tap: CGEventTapLocation.cghidEventTap)
        }
        doKey(down: true)
        doKey(down: false)
    }
}
