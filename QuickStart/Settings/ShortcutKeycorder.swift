//
//  TriggerKeycorder.swift
//  Loop
//
//  Created by Kai Azim on 2023-09-11.
//

import SwiftUI

struct ShortcutKeycorder: View {
    @EnvironmentObject private var keycorderModel: KeycorderModel

    let keyLimit: Int = 5

    @Binding private var validCurrentKey: Set<CGKeyCode>
    @State private var selectionKey: Set<CGKeyCode>

    @State private var eventMonitor: NSEventMonitor?
    @State private var shouldError: Bool = false
    @State private var shouldShake: Bool = false
    @State private var isHovering: Bool = false
    @State private var isActive: Bool = false
    @State private var isCurrentlyPressed: Bool = false
    @State private var tooManyKeysPopup: Bool = false

    @State private var errorMessage: Text = Text("") // We use Text here for String interpolation with images

    init(_ key: Binding<Set<CGKeyCode>>) {
        self._validCurrentKey = key
        _selectionKey = State(initialValue: key.wrappedValue)
    }

    var body: some View {
        Button {
            guard !self.isActive else { return }
            self.startObservingKeys()
        } label: {
            HStack(spacing: 5) {
                if self.selectionKey.isEmpty {
                    Text(self.isActive ? "Set shortcut keys…" : "None")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(5)
                        .padding(.horizontal, 8)
                        .background {
                            ZStack {
                                RoundedRectangle(cornerRadius: 6)
                                    .foregroundStyle(.background)
                                RoundedRectangle(cornerRadius: 6)
                                    .strokeBorder(
                                        .tertiary.opacity((self.isHovering || self.isActive) ? 1 : 0.5),
                                        lineWidth: 1
                                    )
                            }
                        }
                        .fixedSize(horizontal: true, vertical: false)
                } else {
                    ForEach(self.selectionKey.sorted(by: >), id: \.self) { key in
                        if let systemImage = key.systemImage {
                            Text("\(Image(systemName: systemImage))")
                        } else if let humanReadable = key.humanReadable {
                            Text(humanReadable)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .aspectRatio(1, contentMode: .fill)
                    .padding(5)
                    .background {
                        ZStack {
                            RoundedRectangle(cornerRadius: 6)
                                .foregroundStyle(.background)
                            RoundedRectangle(cornerRadius: 6)
                                .strokeBorder(.tertiary.opacity(self.isHovering ? 1 : 0.5), lineWidth: 1)
                        }
                    }
                    .fixedSize(horizontal: true, vertical: false)
                }
            }
            .fontDesign(.monospaced)
            .contentShape(Rectangle())
        }
        .modifier(ShakeEffect(shakes: self.shouldShake ? 2 : 0))
        .animation(Animation.default, value: shouldShake)
        .popover(isPresented: $tooManyKeysPopup, arrowEdge: .bottom) {
            Text("You can only use up to \(keyLimit) keys in your shortcut key.")
                .multilineTextAlignment(.center)
                .padding(8)
        }
        .onHover { hovering in
            self.isHovering = hovering
        }
        .onChange(of: keycorderModel.eventMonitor) {
            if keycorderModel.eventMonitor != self.eventMonitor {
                self.finishedObservingKeys(wasForced: true)
            }
        }
        .onChange(of: self.validCurrentKey) {
            if self.selectionKey != self.validCurrentKey {
                self.selectionKey = self.validCurrentKey
            }
        }
        .buttonStyle(.plain)
        .scaleEffect(self.isCurrentlyPressed ? 0.9 : 1)
    }

    func startObservingKeys() {
        self.selectionKey = []
        self.isActive = true
        self.eventMonitor = NSEventMonitor(scope: .local, eventMask: [.keyDown, .keyUp, .flagsChanged]) { event in
            if event.type == .flagsChanged {
                self.shouldError = false
                self.selectionKey.insert(event.keyCode.baseModifier)
                withAnimation(.snappy(duration: 0.1)) {
                    self.isCurrentlyPressed = true
                }
            }

            if event.type == .keyUp ||
               (event.type == .flagsChanged &&  !self.selectionKey.isEmpty && event.modifierFlags.rawValue == 256) {
                self.finishedObservingKeys()
                return
            }

            if event.type == .keyDown  && !event.isARepeat {
                if event.keyCode == CGKeyCode.kVK_Escape {
                    finishedObservingKeys(wasForced: true)
                    return
                }

                if self.selectionKey.count >= keyLimit {
                    self.errorMessage = Text(
                        "You can only use up to \(keyLimit) keys in a keybind, including the trigger key."
                    )
                    self.shouldShake.toggle()
                    self.shouldError = true
                } else {
                    self.shouldError = false
                    self.selectionKey.insert(event.keyCode)
                    withAnimation(.snappy(duration: 0.1)) {
                        self.isCurrentlyPressed = true
                    }
                }

            }
        }

        self.eventMonitor!.start()
        keycorderModel.eventMonitor = eventMonitor
    }

    func finishedObservingKeys(wasForced: Bool = false) {
        var willSet = !wasForced

        if self.selectionKey.count > self.keyLimit {
            willSet = false
            self.shouldShake.toggle()
            self.tooManyKeysPopup = true
        }

        self.isActive = false
        withAnimation(.snappy(duration: 0.1)) {
            self.isCurrentlyPressed = false
        }

        if willSet {
            // Set the valid keybind to the current selected one
            self.validCurrentKey = selectionKey
        } else {
            // Set preview keybind back to previous one
            self.selectionKey = self.validCurrentKey
        }

        self.eventMonitor?.stop()
        self.eventMonitor = nil
    }
}
