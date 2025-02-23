//
//  ActionButton.swift
//  MaxVision
//
//  Created by hujinyou on 2025/2/15.
//

import SwiftUI

struct ActionButton: View {
    @Environment(\.isEnabled) private var isEnabled
    
    var title: LocalizedStringKey
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .foregroundStyle(isEnabled ? .white : .white.opacity(0.6))
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(isEnabled ? .blue : .blue.opacity(0.6))
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(.borderless)
    }
}

