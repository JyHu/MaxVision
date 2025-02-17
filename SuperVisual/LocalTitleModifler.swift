//
//  LocalTitleModifler.swift
//  SuperVisual
//
//  Created by hujinyou on 2025/2/17.
//

import SwiftUI

struct LocalTitleModifler: ViewModifier {
    @State private var titleValue: String = " - "
    
    @EnvironmentObject var languageManager: LanguageManager
    
    let navigationType: NavigationType
    
    init(navigationType: NavigationType) {
        self.navigationType = navigationType
    }
    
    func body(content: Content) -> some View {
        content
            .onChange(of: languageManager.locale) { oldValue, newValue in
                self.titleValue = languageManager.language.titleFor(navigationType)
            }
            .navigationTitle(titleValue)
            .onAppear {
                self.titleValue = languageManager.language.titleFor(navigationType)
            }
    }
}

extension View {
    func localTitle(_ navigationType: NavigationType) -> some View {
        self.modifier(LocalTitleModifler(navigationType: navigationType))
    }
}
