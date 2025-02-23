//
//  RGBComponent.swift
//  MaxVision
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
    
    let rgbString: String
    let hexString: String
    
    init(red: Int, green: Int, blue: Int) {
        self.red = red
        self.green = green
        self.blue = blue
        
        self.rgbString = "\(red),\(green),\(blue)"
        self.hexString = String(format: "%02X%02X%02X", red, green, blue)
    }
    
    var color: Color {
        Color(red: Double(red) / 255, green: Double(green) / 255, blue: Double(blue) / 255)
    }
}
