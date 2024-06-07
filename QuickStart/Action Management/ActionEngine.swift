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
        let action = direction.toAction(fourParts: Defaults[.fourParts])
        
        switch action.actionType {
        case .builtin:
            executeBuiltinAction(action: action.builtinAction)
        case .shortcuts:
            executeShortcutAction(action: action.shortcutKeys)
        case .appleScript:
            executeAppleScript(action: action.scriptURL)
        case .application:
            executeStartApp(action: action.appInstallationPath)
        }
    }
    
    static func executeStartApp(action: String?) {
        if let url = action {
            let openURL = NSURL(fileURLWithPath: url, isDirectory: true) as URL
            let configuration = NSWorkspace.OpenConfiguration()
            NSWorkspace.shared.openApplication(at: openURL,
                                               configuration: configuration,
                                               completionHandler: nil)
        }
    }
    
    static func executeAppleScript(action: URL?) {
        if let url = action {
            var error: NSDictionary?
            if let scriptObject = NSAppleScript(contentsOf: url, error: &error) {
                if let scriptResult = scriptObject
                    .executeAndReturnError(&error)
                    .stringValue {
                        print(scriptResult)
                } else if (error != nil)  {
                    print("error: ",error!)
                }
            }
        }
    }
    
    static func executeShortcutAction(action: Set<CGKeyCode>) {
        let src = CGEventSource(stateID: .hidSystemState)
        var keyDownList: [CGEvent?] = []
        var keyUpList: [CGEvent?] = []
        
        for keycode in action {
            if !keycode.isModifier {
                keyDownList.append(CGEvent(keyboardEventSource: src, virtualKey: keycode, keyDown: true))
                keyUpList.append(CGEvent(keyboardEventSource: src, virtualKey: keycode, keyDown: false))
            }
        }
        
        var flags: [CGEventFlags] = []
        for keycode in action {
            if keycode.isModifier {
                switch keycode {
                case .kVK_Control, .kVK_RightControl:
                    flags.append(.maskControl)
                case .kVK_Command, .kVK_RightCommand:
                    flags.append(.maskCommand)
                case .kVK_Shift, .kVK_RightShift:
                    flags.append(.maskShift)
                case .kVK_Option, .kVK_RightOption:
                    flags.append(.maskAlternate)
                case .kVK_Function:
                    flags.append(.maskSecondaryFn)
                default:
                    print("impossible modifier keycode", keycode)
                }
            }
        }
        
        if flags.count > 0 {
            var combinedFlags: CGEventFlags = flags[0]
            for flag in flags {
                combinedFlags = CGEventFlags(rawValue: flag.rawValue | combinedFlags.rawValue)
            }
            
            for event in keyDownList {
                event?.flags = combinedFlags
            }
            
            for event in keyUpList {
                event?.flags = combinedFlags
            }
        }
        
        let loc = CGEventTapLocation.cghidEventTap
        for event in keyDownList {
            event?.post(tap: loc)
        }
        
        for event in keyUpList {
            event?.post(tap: loc)
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
