//
//  SettingsView.swift
//  QuickStart
//
//  Created by Yuning Wang on 5/30/24.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            Button {
                HIDPostAuxKey(key: 16)
            } label: {
                Text("change")
            }
            Text("abc")
            RadialMenuView()
        }
    }
}

func HIDPostAuxKey(key: UInt32) {
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

#Preview {
    SettingsView()
}
