//
//  Bundle+Extensions.swift
//  Loop
//
//  Created by Kai Azim on 2023-06-14.
//

import Foundation

// Returns the current build number
extension Bundle {
    var appName: String { getInfo("CFBundleName")  }
    var displayName: String { getInfo("CFBundleDisplayName") }
    var bundleID: String { getInfo("CFBundleIdentifier") }
    var copyright: String { getInfo("NSHumanReadableCopyright") }

    var appBuild: String { getInfo("CFBundleVersion") }
    var appVersion: String { getInfo("CFBundleShortVersionString") }

    func getInfo(_ str: String) -> String {
        infoDictionary?[str] as? String ?? "⚠️"
    }
}
