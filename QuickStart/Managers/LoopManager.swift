//
//  LoopManager.swift
//  Loop
//
//  Created by Kai Azim on 2023-08-15.
//

import SwiftUI
import Defaults

// swiftlint:disable:next type_body_length
class LoopManager: ObservableObject {
    // Size Adjustment
    static var sidesToAdjust: Edge.Set?
    static var lastTargetFrame: CGRect = .zero
    static var canAdjustSize: Bool = true

    private let keybindMonitor = KeybindMonitor.shared

    private let radialMenuController = RadialMenuController()

    private var currentlyPressedModifiers: Set<CGKeyCode> = []
    private var isLoopActive: Bool = false

    private var flagsChangedEventMonitor: EventMonitor?
    private var mouseMovedEventMonitor: EventMonitor?
    private var keyDownEventMonitor: EventMonitor?
    private var middleClickMonitor: EventMonitor?
    private var lastTriggerKeyClick: Date = .now

    @Published var currentAction: ActionDirection = .noAction
    private var initialMousePosition: CGPoint = CGPoint()
    private var angleToMouse: Angle = Angle(degrees: 0)
    private var distanceToMouse: CGFloat = 0

    private var triggerDelayTimer: Timer? {
        willSet {
            triggerDelayTimer?.invalidate()
        }
    }

    func startObservingKeys() {
        flagsChangedEventMonitor = NSEventMonitor(
            scope: .global,
            eventMask: .flagsChanged,
            handler: handleLoopKeypress(_:)
        )

        mouseMovedEventMonitor = NSEventMonitor(
            scope: .global,
            eventMask: [.mouseMoved, .otherMouseDragged],
            handler: mouseMoved(_:)
        )

        middleClickMonitor = CGEventMonitor(
            eventMask: [.otherMouseDragged, .otherMouseUp],
            callback: handleMiddleClick(cgEvent:)
        )

        keyDownEventMonitor = NSEventMonitor(
            scope: .global,
            eventMask: .keyDown
        ) { _ in 
            if Defaults[.doubleClickToTrigger] &&
                abs(self.lastTriggerKeyClick.timeIntervalSinceNow) < NSEvent.doubleClickInterval {
                self.lastTriggerKeyClick = Date.distantPast
            }
        }

        flagsChangedEventMonitor!.start()
        middleClickMonitor!.start()
        keyDownEventMonitor!.start()
        
        print("loop manager started")
    }

    private func mouseMoved(_ event: NSEvent) {
        guard isLoopActive else { return }
        keybindMonitor.canPassthroughSpecialEvents = false

        let noActionDistance: CGFloat = 10

        let currentMouseLocation = NSEvent.mouseLocation
        let mouseAngle = Angle(radians: initialMousePosition.angle(to: currentMouseLocation))
        let mouseDistance = initialMousePosition.distanceSquared(to: currentMouseLocation)

        // Return if the mouse didn't move
        if (mouseAngle == angleToMouse) && (mouseDistance == distanceToMouse) {
            return
        }

        // Get angle & distance to mouse
        angleToMouse = mouseAngle
        distanceToMouse = mouseDistance

        var newDirection: ActionDirection = .noAction

        // If mouse over 50 points away, select half or quarter positions
        if distanceToMouse > pow(50 - Defaults[.radialMenuThickness], 2) {
            if Defaults[.fourParts] {
                switch Int((angleToMouse.normalized().degrees + 45) / 90) {
                case 0, 4:
                    newDirection = .right
                case 1:
                    newDirection = .bottom
                case 2:
                    newDirection = .left
                case 3:
                    newDirection = .top
                default:
                    newDirection = .noAction
                }
            }
            else {
                switch Int((angleToMouse.normalized().degrees + 22.5) / 45) {
                case 0, 8:
                    newDirection = .right
                case 1:
                    newDirection = .bottomRight
                case 2:
                    newDirection = .bottom
                case 3:
                    newDirection = .bottomLeft
                case 4:
                    newDirection = .left
                case 5:
                    newDirection = .topLeft
                case 6:
                    newDirection = .top
                case 7:
                    newDirection = .topRight
                default:
                    newDirection = .noAction
                }
            }
        } else if distanceToMouse < pow(noActionDistance, 2) {
            newDirection = .noAction
        } else {
            newDirection = .noAction
        }

        if newDirection != currentAction {
            changeAction(newDirection)
        }
    }

    private func performHapticFeedback() {
        if Defaults[.hapticFeedback] {
            NSHapticFeedbackManager.defaultPerformer.perform(
                NSHapticFeedbackManager.FeedbackPattern.alignment,
                performanceTime: NSHapticFeedbackManager.PerformanceTime.now
            )
        }
    }

    private func changeAction(_ action: ActionDirection) {
        let newAction = action
        
        if newAction != currentAction {
            currentAction = newAction

            if Defaults[.hideUntilDirectionIsChosen] {
                openWindows()
            }
            DispatchQueue.main.async {
                Notification.Name.updateUIDirection.post(userInfo: ["action": self.currentAction])
            }

            print("Window action changed: \(currentAction)")
        }
    }

    func handleMiddleClick(cgEvent: CGEvent) -> Unmanaged<CGEvent>? {
        if let event = NSEvent(cgEvent: cgEvent), event.buttonNumber == 2, Defaults[.middleClickTriggersLoop] {
            if event.type == .otherMouseDragged && !isLoopActive {
                openLoop()
            }

            if event.type == .otherMouseUp && isLoopActive {
                closeLoop()
            }
        }
        return Unmanaged.passUnretained(cgEvent)
    }

    private func handleTriggerDelay() {
        if triggerDelayTimer == nil {
            triggerDelayTimer = Timer.scheduledTimer(
                withTimeInterval: Double(Defaults[.triggerDelay]),
                repeats: false
            ) { _ in
                self.openLoop()
            }
        }
    }

    private func handleDoubleClickToTrigger(_ useTriggerDelay: Bool) {
        if abs(lastTriggerKeyClick.timeIntervalSinceNow) < NSEvent.doubleClickInterval {
            if useTriggerDelay {
                handleTriggerDelay()
            } else {
                openLoop()
            }
        }
    }

    private func handleLoopKeypress(_ event: NSEvent) {
        triggerDelayTimer = nil

        let previousModifiers = currentlyPressedModifiers
        processModifiers(event)

        let triggerKey = Defaults[.triggerKey]
        let wasKeyDown = event.type == .keyDown || currentlyPressedModifiers.count > previousModifiers.count

        if wasKeyDown, triggerKey.isSubset(of: currentlyPressedModifiers) {
            guard
                !isLoopActive,

                // This makes sure that the amount of keys being pressed is not more than the actual trigger key
                currentlyPressedModifiers.count <= triggerKey.count
            else {
                return
            }

            let useTriggerDelay = Defaults[.triggerDelay] > 0.1
            let useDoubleClickTrigger = Defaults[.doubleClickToTrigger]

            if useDoubleClickTrigger {
                guard currentlyPressedModifiers.sorted() == Defaults[.triggerKey].sorted() else { return }
                handleDoubleClickToTrigger(useTriggerDelay)
            } else if useTriggerDelay {
                handleTriggerDelay()
            } else {
                openLoop()
            }
            lastTriggerKeyClick = .now
        } else {
            closeLoop()
        }
    }

    private func processModifiers(_ event: NSEvent) {
        if event.modifierFlags.wasKeyUp {
            currentlyPressedModifiers = []
        } else if currentlyPressedModifiers.contains(event.keyCode) {
            currentlyPressedModifiers.remove(event.keyCode)
        } else {
            currentlyPressedModifiers.insert(event.keyCode)
        }

        // Backup system in case keys are pressed at the exact same time
        let flags = event.modifierFlags.convertToCGKeyCode()
        if flags.count != currentlyPressedModifiers.count {
            for key in flags where CGKeyCode.keyToImage.contains(where: { $0.key == key }) {
                if !currentlyPressedModifiers.map({ $0.baseModifier }).contains(key) {
                    currentlyPressedModifiers.insert(key)
                }
            }
        }
    }

    private func openLoop() {
        guard isLoopActive == false else { return }

        currentAction = .noAction

        // Ensure accessibility access
//        guard AccessibilityManager.getStatus() else { return }

        initialMousePosition = NSEvent.mouseLocation

        if !Defaults[.disableCursorInteraction] {
            mouseMovedEventMonitor!.start()
        }

        if !Defaults[.hideUntilDirectionIsChosen] {
            openWindows()
        }


        keybindMonitor.start()

        isLoopActive = true
    }

    private func closeLoop(forceClose: Bool = false) {
        guard isLoopActive == true else { return }

        triggerDelayTimer = nil
        closeWindows()

        keybindMonitor.stop()
        mouseMovedEventMonitor!.stop()

        currentlyPressedModifiers = []

        if currentAction != .noAction, isLoopActive {
            ActionEngine.executeAction(direction: currentAction)
        }
        
        currentAction = .noAction
        DispatchQueue.main.async {
            Notification.Name.updateUIDirection.post(userInfo: ["action": self.currentAction])
        }
        
        isLoopActive = false
        LoopManager.sidesToAdjust = nil
        LoopManager.lastTargetFrame = .zero
        LoopManager.canAdjustSize = true
    }

    private func openWindows() {
        radialMenuController.open(
            position: initialMousePosition
        )
    }

    private func closeWindows() {
        radialMenuController.close()
    }
}
