//
//  MyGroupBox.swift
//  MaxVision
//
//  Created by hujinyou on 2025/2/23.
//

import SwiftUI

struct MyGroupBox<T: View>: View {
    
    let title: LocalizedStringKey?
    @ViewBuilder var content: () -> T

    init(_ title: LocalizedStringKey? = nil, @ViewBuilder content: @escaping () -> T) {
        self.title = title
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
        let c = VStack {
            content()
        }
        
#if os(macOS)
        c.padding(.all, 5)
        #else
        c
        #endif
    }
}
