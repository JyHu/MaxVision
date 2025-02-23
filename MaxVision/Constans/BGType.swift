//
//  BGType.swift
//  MaxVision
//
//  Created by hujinyou on 2025/2/16.
//

import SwiftUI

enum BGType: String {
    case light
    case dark
    
    var color: Color {
        switch self {
            case .light: return Color.white
            case .dark: return Color.black
        }
    }
    
    var colorScheme: ColorScheme {
        switch self {
        case .light: return .light
        case .dark: return .dark
        }
    }
}

