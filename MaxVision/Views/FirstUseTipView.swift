//
//  FirstUseTipView.swift
//  MaxVision
//
//  Created by hujinyou on 2025/2/23.
//

import SwiftUI

struct FirstUseTipView: View {
    @Environment(\.dismiss) private var dismissAction
    @AppStorage("com.auu.confirmed") private var confirmed: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    Text(lLocalizationFirstTipsNameKey)
                }
                
                ActionButton(title: lLocalizationOKNameKey) {
                    dismissAction()
                }
            }
            .padding(.all, 20)
#if !os(macOS)
            .navigationBarTitleDisplayMode(.inline)
#endif
            .navigationTitle(lTipsNameKey)
        }
        .onDisappear {
            confirmed = true
        }
    }
}

