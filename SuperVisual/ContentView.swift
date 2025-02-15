//
//  ContentView.swift
//  SuperVisual
//
//  Created by hujinyou on 2025/2/13.
//

import SwiftUI

let spaceWidth: Double = 1

struct ContentView: View {
    @State var showSetting: Bool = false
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
                            if viewModel.checkRes != .checking {
                                context.draw(Text("✅"), in: rect)
                            } else {
                                context.draw(Text("❌"), in: rect)
                            }
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
                    
                Button {
                    viewModel.general()
                } label: {
                    Text("Next")
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(.blue)
                .clipShape(RoundedRectangle(cornerRadius: 8))

                Spacer()
                
                Button {
                    viewModel.showAnswer()
                } label: {
                    Text("Check")
                }
                .foregroundStyle(viewModel.checkRes != .checking ? .white.opacity(0.6) : .white)
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(viewModel.checkRes != .checking ? .blue.opacity(0.6) : .blue)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .disabled(viewModel.checkRes != .checking)
                
                Spacer()
                
                Button {
                    showSetting = true
                } label: {
                    Text("Setting")
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(.blue)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .frame(height: 60)
        }
        .padding()
        .navigationTitle("Super Visual")
        .navigationBarTitleDisplayMode(.inline)
        .popover(isPresented: $showSetting) {
            SettingView(viewModel: viewModel)
        }
    }
}

#Preview {
    ContentView()
}
