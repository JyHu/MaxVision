//
//  SuperVisualApp.swift
//  SuperVisual
//
//  Created by hujinyou on 2025/2/13.
//

import SwiftUI

@main
struct SuperVisualApp: App {
    @ObservedObject var languageManager = LanguageManager()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView()
                    .environment(\.locale, languageManager.locale)
                    .environmentObject(languageManager)
            }
        }
    }
}
