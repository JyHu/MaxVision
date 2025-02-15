//
//  InfoView.swift
//  SuperVisual
//
//  Created by hujinyou on 2025/2/15.
//

import SwiftUI

struct InfoView: View {
    let normalColorInfo: RGBInfo?
    let quesColorInfo: RGBInfo?
    
    var body: some View {
        NavigationStack {
            makeContent()
            .navigationTitle("Help")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    @ViewBuilder
    func makeContent() -> some View {
        if let normalColorInfo = normalColorInfo, let quesColorInfo = quesColorInfo {
            ScrollView {
                Grid(horizontalSpacing: 0) {
                    GridRow {
                        HStack {
                            Spacer()
                            
                            Text("Normal")
                        }
                        .padding(.trailing, 8)
                        
                        HStack {
                            Text("Special")
                            
                            Spacer()
                        }
                        .padding(.leading, 8)
                    }
                    
                    GridRow {
                        HStack {
                            Spacer()
                            
                            Text("\(normalColorInfo.red), \(normalColorInfo.green), \(normalColorInfo.blue)")
                        }
                        .padding(.trailing, 8)
                        
                        HStack {
                            Text("\(quesColorInfo.red), \(quesColorInfo.green), \(quesColorInfo.blue)")
                            
                            Spacer()
                        }
                        .padding(.leading, 8)
                    }
                    .fontDesign(.monospaced)
                    
                    
                    GridRow {
                        Rectangle()
                            .fill(normalColorInfo.color)
                            .frame(height: 120)
                            .frame(maxWidth: .infinity)
                        
                        Rectangle()
                            .fill(quesColorInfo.color)
                            .frame(height: 120)
                            .frame(maxWidth: .infinity)
                    }
                }
            }
        } else {
            VStack {
                Text("No Info")
                    .font(.title)
                    .foregroundColor(.secondary)
            }
        }
    }
}
