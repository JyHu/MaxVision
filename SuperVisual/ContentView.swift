//
//  ContentView.swift
//  SuperVisual
//
//  Created by hujinyou on 2025/2/13.
//

import SwiftUI

let spaceWidth: Double = 1

struct ContentView: View {
    @State var showSetting = false
    @State var showInfo = false
    @ObservedObject var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            Canvas { context, size in
                let itemWidth = (size.width - Double(viewModel.columns - 1)) / Double(viewModel.columns)
                let itemHeight = (size.height - Double(viewModel.rows - 1)) / Double(viewModel.rows)
                
                let length = min(itemWidth, itemHeight)
                
                let top = (size.height - length * Double(viewModel.rows) - spaceWidth * Double((viewModel.rows - 1))) / 2
                let leading = (size.width - length * Double(viewModel.columns) - spaceWidth * Double((viewModel.columns - 1))) / 2
                
                for row in 0..<viewModel.rows {
                    for col in 0..<viewModel.columns {
                        let rect = CGRectMake(
                            (length + spaceWidth) * Double(col) + leading,
                            (length + spaceWidth) * Double(row) + top,
                            length, length
                        )
                        
                        let quested: Bool = row == viewModel.posy && col == viewModel.posx
                        let color = quested ? viewModel.quesColor : viewModel.color
                        
                        context.fill(Path(rect), with: .color(color))
                        
                        let selected: Bool = row == viewModel.selectedY && col == viewModel.selectedX

                        if selected {
                            let image = Image(systemName: viewModel.checkRes != .checking ? "checkmark" : "xmark")
                            
                            context.draw(image, at: CGPoint(
                                x: rect.origin.x + length / 2,
                                y: rect.origin.y + length / 2
                            ))
                        }
                    }
                }
                
                viewModel.size = size
                viewModel.leading = leading
                viewModel.top = top
                viewModel.length = length
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onTapGesture { point in
                viewModel.tap(at: point)
            }
            
            HStack {
                Spacer()
                
                ActionButton(title: "Check") {
                    viewModel.showAnswer()
                }.disabled(viewModel.checkRes != .checking)
                
                Spacer()
                
                ActionButton(title: "Help") {
                    showInfo = true
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            
            HStack {
                Spacer()
                
                ActionButton(title: "Next") {
                    viewModel.general()
                }
                
                Spacer()
                
                ActionButton(title: "Setting") {
                    showSetting = true
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
        .navigationTitle("Super Visual")
        .navigationBarTitleDisplayMode(.inline)
        .popover(isPresented: $showSetting) {
            SettingView(viewModel: viewModel)
        }
        .popover(isPresented: $showInfo) {
            InfoView(
                normalColorInfo: viewModel.normalColorInfo,
                quesColorInfo: viewModel.quesColorInfo
            )
            .presentationDetents([.medium, .large])
        }
    }
}

#Preview {
    ContentView()
}
