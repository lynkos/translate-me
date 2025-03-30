//
//  TranslateMeApp.swift
//  TranslateMe
//
//  Created by Kiran Brahmatewari on 3/29/25.
//

import SwiftUI
import FirebaseCore

@main
struct TranslateMeApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
