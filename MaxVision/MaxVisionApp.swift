//
//  MaxVisionApp.swift
//  MaxVision
//
//  Created by hujinyou on 2025/2/23.
//

import SwiftUI

@main
struct MaxVisionApp: App {
    @ObservedObject var languageManager = LanguageManager()
    
    var body: some Scene {
        WindowGroup {
            let content = ContentView()
                .environment(\.locale, languageManager.locale)
                .environmentObject(languageManager)
#if os(macOS)
            content
#else
            NavigationStack {
                content
            }
#endif
        }
    }
}
