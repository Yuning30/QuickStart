//
//  AppListManager.swift
//  Loop
//
//  Created by Dirk Mika on 11.03.24.
//

import SwiftUI
import Algorithms

struct InstalledApp: Identifiable {
    var id: String { bundleID }
    var bundleID: String
    var icon: NSImage
    var displayName: String
    var installationFolder: String
    var installationPath: String
}

class AppListManager: ObservableObject {


    private var qry = NSMetadataQuery()

    @Published var installedApps = [InstalledApp]()

    init() {
        self.startQuery()
    }

    deinit {
        qry.stop()
    }

    private func startQuery() {
        qry.predicate = NSPredicate(format: "kMDItemContentType == 'com.apple.application-bundle'")
        if let appFolder = FileManager.default.urls(for: .applicationDirectory, in: .localDomainMask).first {
            qry.searchScopes = [appFolder]
        }

        NotificationCenter.default.addObserver(
            forName: .NSMetadataQueryDidFinishGathering,
            object: nil,
            queue: nil,
            using: queryDidFinishGathering
        )
        qry.start()
    }

    private func queryDidFinishGathering(notification: Notification) {
        if let items  = qry.results as? [NSMetadataItem] {
            self.installedApps = items.compactMap { item in
                guard
                    let bundleId = item.value(forAttribute: NSMetadataItemCFBundleIdentifierKey) as? String,
                    let displayName = item.value(forAttribute: NSMetadataItemDisplayNameKey) as? String,
                    let path = item.value(forAttribute: NSMetadataItemPathKey) as? String,
                    let installationFolder = URL(string: path)?.deletingLastPathComponent().path(percentEncoded: false),
                    let installationPath = URL(string:path)?.path(percentEncoded: false)
                else {
                    return nil
                }
                let icon = NSWorkspace.shared.icon(forFile: path)
                return InstalledApp(
                    bundleID: bundleId,
                    icon: icon,
                    displayName: displayName,
                    installationFolder: installationFolder,
                    installationPath: installationPath
                )
            }
        }
    }
}
