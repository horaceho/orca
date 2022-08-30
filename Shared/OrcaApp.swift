//
//  OrcaApp.swift
//  Shared
//
//  Created by Horace Ho on 26/8/2022.
//

import SwiftUI
import SwiftyDropbox

@main
struct OrcaApp: App {
    init() {
        DropboxClientsManager.setupWithAppKey("xxxxxxxxxxxxxxx")
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .accentColor(.gray)
        }
    }
}
