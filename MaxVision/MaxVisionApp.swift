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
            NavigationStack {
                ContentView()
                    .environment(\.locale, languageManager.locale)
                    .environmentObject(languageManager)
            }
        }
    }
}
