//
//  ActionEngine.swift
//  QuickStart
//
//  Created by Yuning Wang on 6/2/24.
//

import Foundation
import SwiftUI

class ActionEngine {
    static func executeAction(direction: ActionDirection) {
        switch direction {
        case .bottom:
            NextSong()
        case .top:
            StartPause()
        default:
            return
        }
    }
    
    static func NextSong() {
        print("next song")
        return
    }
    
    static func StartPause() {
        print("song start/psuse")
        HIDPostAuxKey(key: 16)
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
