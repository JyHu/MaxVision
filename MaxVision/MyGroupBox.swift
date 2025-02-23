//
//  MyGroupBox.swift
//  MaxVision
//
//  Created by hujinyou on 2025/2/23.
//

import SwiftUI

struct MyGroupBox<T: View>: View {
    
    let title: LocalizedStringKey?
    let spacing: Double
    @ViewBuilder var content: () -> T

    init(_ title: LocalizedStringKey? = nil, spacing: Double = 8, @ViewBuilder content: @escaping () -> T) {
        self.title = title
        self.spacing = spacing
        self.content = content
    }
    
    var body: some View {
        if let title {
            GroupBox(title) {
                makeContent()
            }
        } else {
            GroupBox {
                makeContent()
            }
        }
    }
    
    @ViewBuilder
    func makeContent() -> some View {
        let c = VStack(spacing: spacing) {
            content()
        }
        
#if os(macOS)
        c.padding(.all, 5)
        #else
        c
        #endif
    }
}
