//
//  RGBComponent.swift
//  SuperVisual
//
//  Created by hujinyou on 2025/2/16.
//

import SwiftUI

enum RGBComponent: String, Identifiable, CaseIterable {
    case R
    case G
    case B
    
    var id: String { rawValue }
    
    var name: LocalizedStringKey {
        switch self {
        case .R: lRedNameKey
        case .G: lGreenNameKey
        case .B: lBlueNameKey
        }
    }
}

struct RGBInfo {
    let red: Int
    let green: Int
    let blue: Int
    
    var color: Color {
        Color(red: Double(red) / 255, green: Double(green) / 255, blue: Double(blue) / 255)
    }
}
