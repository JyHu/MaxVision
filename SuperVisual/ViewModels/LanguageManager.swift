//
//  LanguageManager.swift
//  SuperVisual
//
//  Created by hujinyou on 2025/2/16.
//

import SwiftUI

/// 语言管理器
class LanguageManager: ObservableObject {
    @Published var locale: Locale = .current  // 默认跟随系统
    
    @Published var language: Language = .english {
        didSet {
            UserDefaults.standard.set(language.rawValue, forKey: "com.auu.language")
            UserDefaults.standard.synchronize()
            
            changeLanguage(to: language.rawValue)
        }
    }

    init() {
        if let languageCode = UserDefaults.standard.string(forKey: "com.auu.language") {
            language = Language(rawValue: languageCode) ?? .english
        } else if let languageCode = locale.language.languageCode?.identifier {
            language = Language(rawValue: languageCode) ?? .english
        } else {
            language = .english
        }
    }
    
    /// 切换语言
    func changeLanguage(to languageCode: String) {
        locale = Locale(identifier: languageCode)
    }
}
