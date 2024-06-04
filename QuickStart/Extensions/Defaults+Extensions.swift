//
//  Defaults+Extensions.swift
//  Loop
//
//  Created by Kai Azim on 2023-06-14.
//

import SwiftUI
import Defaults

// Add variables for default values (which are stored even then the app is closed)
extension Defaults.Keys {
    static let fourParts = Key<Bool>("fourParts", default: false)
    static let eightActions = Key<[SegmentDescription]>("eightActions", default: [SegmentDescription(icon: "square.and.arrow.up.fill", angle: 0)])
    static let fourActions = Key<[SegmentDescription]>("fourActions", default: [SegmentDescription(icon: "square.and.arrow.up.fill", angle: 0), SegmentDescription(icon: "playpause.circle", angle: 90), SegmentDescription(icon: "circle.square", angle: 180), SegmentDescription(icon: "circle.square", angle: 270)])
    
    static let hapticFeedback = Defaults.Key<Bool>("hapticFeedback", default: true)
    static let launchAtLogin = Key<Bool>("launchAtLogin", default: false)
    static let hideMenuBarIcon = Key<Bool>("hideMenuBarIcon", default: false)
    static let currentIcon = Key<String>("currentIcon", default: "AppIcon-Classic")
    static let notificationWhenIconUnlocked = Key<Bool>("notificationWhenIconUnlocked", default: true)
    static let timesLooped = Key<Int>("timesLooped", default: 0)
    static let windowSnapping = Key<Bool>("windowSnapping", default: false) // BETA
    static let animateWindowResizes = Key<Bool>("animateWindowResizes", default: false) // BETA
//    static let padding = Key<PaddingModel>("padding", default: .zero)
    static let restoreWindowFrameOnDrag = Key<Bool>("restoreWindowFrameOnDrag", default: false)
    static let resizeWindowUnderCursor = Key<Bool>("resizeWindowUnderCursor", default: false)
    static let focusWindowOnResize = Key<Bool>("focusWindowOnResize", default: true)
//    static let animationConfiguration = Key<AnimationConfiguration>("animationConfiguration", default: .smooth)

    static let useSystemAccentColor = Key<Bool>("useSystemAccentColor", default: true)
    static let customAccentColor = Key<Color>("customAccentColor", default: Color(.white))
    static let useGradient = Key<Bool>("useGradient", default: true)
    static let gradientColor = Key<Color>("gradientColor", default: Color(.black))

    static let radialMenuVisibility = Key<Bool>("radialMenuVisibility", default: true)
    static let radialMenuCornerRadius = Key<CGFloat>("radialMenuCornerRadius", default: 50)
    static let radialMenuThickness = Key<CGFloat>("radialMenuThickness", default: 22)
    static let hideUntilDirectionIsChosen = Key<Bool>("hideUntilDirectionIsChosen", default: false)
    static let disableCursorInteraction = Key<Bool>("disableCursorInteraction", default: false)

    static let triggerKey = Key<Set<CGKeyCode>>("trigger", default: [.kVK_Function])
    static let doubleClickToTrigger = Key<Bool>("doubleClickToTrigger", default: false)
    static let triggerDelay = Key<Double>("triggerDelay", default: 0)
    static let middleClickTriggersLoop = Key<Bool>("middleClickTriggersLoop", default: false)

    static let previewVisibility = Key<Bool>("previewVisibility", default: true)
    static let previewCornerRadius = Key<CGFloat>("previewCornerRadius", default: 10)
    static let previewPadding = Key<CGFloat>("previewPadding", default: 10)
    static let previewBorderThickness = Key<CGFloat>("previewBorderThickness", default: 5)

//    static let keybinds = Key<[WindowAction]>("keybinds", default: [
//        WindowAction(.maximize, keybind: [.kVK_Space]),
//        WindowAction(.center, keybind: [.kVK_Return]),
//
//        WindowAction(.init(localized: .init("Top Cycle", defaultValue: "Top Cycle")), [
//            .init(.topHalf),
//            .init(.topThird),
//            .init(.topTwoThirds)
//        ], [.kVK_UpArrow]),
//        WindowAction(.init(localized: .init("Bottom Cycle", defaultValue: "Bottom Cycle")), [
//            .init(.bottomHalf),
//            .init(.bottomThird),
//            .init(.bottomTwoThirds)
//        ], [.kVK_DownArrow]),
//        WindowAction(.init(localized: .init("Right Cycle", defaultValue: "Right Cycle")), [
//            .init(.rightHalf),
//            .init(.rightThird),
//            .init(.rightTwoThirds)
//        ], [.kVK_RightArrow]),
//        WindowAction(.init(localized: .init("Left Cycle", defaultValue: "Left Cycle")), [
//            .init(.leftHalf),
//            .init(.leftThird),
//            .init(.leftTwoThirds)
//        ], [.kVK_LeftArrow]),
//
//        WindowAction(.topLeftQuarter, keybind: [.kVK_UpArrow, .kVK_LeftArrow]),
//        WindowAction(.topRightQuarter, keybind: [.kVK_UpArrow, .kVK_RightArrow]),
//        WindowAction(.bottomRightQuarter, keybind: [.kVK_DownArrow, .kVK_RightArrow]),
//        WindowAction(.bottomLeftQuarter, keybind: [.kVK_DownArrow, .kVK_LeftArrow])
//    ])

    static let applicationExcludeList = Key<[String]>("applicationExcludeList", default: [])

    static let respectStageManager = Key<Bool>("respectStageManager", default: true)
    static let stageStripSize = Key<CGFloat>("stageStripSize", default: 150)

    static let sizeIncrement = Key<CGFloat>("sizeIncrement", default: 20)

    static let includeDevelopmentVersions = Key<Bool>("includeDevelopmentVersions", default: false)
}
