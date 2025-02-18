//
//  Language.swift
//  SuperVisual
//
//  Created by hujinyou on 2025/2/16.
//

import SwiftUI

enum Language: String, CaseIterable, Identifiable {
    case simpleChinese = "zh-Hans"  // 简体中文
    case traditionalChinese = "zh-Hant"  // 繁体中文
    case english = "en"  // 英语
    case spanish = "es"  // 西班牙语
    case french = "fr"  // 法语
    case german = "de"  // 德语
    case russian = "ru"  // 俄语
    case japanese = "ja"  // 日语
    case korean = "ko"  // 韩语
    case portuguese = "pt"  // 葡萄牙语
    case italian = "it"  // 意大利语
    case thai = "th"  // 泰语
    
    var id: String { self.rawValue }
    
    var displayName: String {
        switch self {
        case .simpleChinese: return "简体中文"
        case .traditionalChinese: return "繁体中文"
        case .english: return "English"
        case .spanish: return "Español"
        case .french: return "Français"
        case .german: return "Deutsch"
        case .russian: return "русский"
        case .japanese: return "日本語"
        case .korean: return "한국어"
        case .portuguese: return "Português"
        case .italian: return "Italiano"
        case .thai: return "ไทย"
        }
    }
}

enum NavigationType {
    case root
    case setting
}

extension Language {
    var settingName: String {
        switch self {
        case .simpleChinese: "设置"
        case .traditionalChinese: "設置"
        case .english: "Setting"
        case .spanish: "Configuración"
        case .french: "Paramètre"
        case .german: "Einstellung"
        case .russian: "Настройка"
        case .japanese: "設定"
        case .korean: "설정"
        case .portuguese: "Configuração"
        case .italian: "Impostazione"
        case .thai: "การตั้งค่า"
        }
    }
    
    var appName: String {
        switch self {
        case .simpleChinese: "超视觉"
        case .traditionalChinese: "超視覺"
        case .english: "Max Vision"
        case .spanish: "Max Visión"
        case .french: "Max Vision"
        case .german: "Max Vision"
        case .russian: "Макс Вижн"
        case .japanese: "マックス・ビジョン"
        case .korean: "맥스 비전"
        case .portuguese: "Max Visão"
        case .italian: "Max Visione"
        case .thai: "แม็กซ์ วิชั่น"
        }
    }
    
    func titleFor(_ navigationType: NavigationType) -> String {
        switch navigationType {
        case .root: appName
        case .setting: settingName
        }
    }
}
