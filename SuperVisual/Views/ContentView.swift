//
//  ContentView.swift
//  SuperVisual
//
//  Created by hujinyou on 2025/2/13.
//

import SwiftUI

struct ContentView: View {
    @State private var showSetting = false
    @State private var showInfo = false
    @ObservedObject var viewModel = ViewModel()
    
    @AppStorage("com.auu.confirmed") private var confirmed: Bool = false
    @State private var begin: Bool = false
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
        VStack {
            GeometryReader { proxy in
                /// 横向
                if proxy.size.width > proxy.size.height {
                    HStack {
                        makeCanvasView()
                        
                        makeActionView(isHorizontal: true)
                            .frame(width: 220)
                    }
                }
                // 纵向
                else {
                    VStack {
                        makeCanvasView()
                        
                        makeActionView(isHorizontal: false)
                    }
                }
            }
        }
        .padding()
        .localTitle(.root)
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(viewModel.increaseContrast ? viewModel.bgType?.colorScheme : nil)
        .sheet(isPresented: $showSetting) {
            SettingView(viewModel: viewModel)
        }
        .sheet(isPresented: $showInfo) {
            let infoView = InfoView(
                normalColorInfo: viewModel.normalColorInfo,
                quesColorInfo: viewModel.quesColorInfo,
                viewModel: viewModel
            )
            
            if horizontalSizeClass == .regular {
                infoView
            } else {
                infoView.presentationDetents([.medium, .large])
            }
        }
        .sheet(isPresented: Binding(get: { !confirmed }, set: { confirmed = !$0 })) {
            FirstUseTipView()
        }
    }
    
    @ViewBuilder
    func makeCanvasView() -> some View {
        GeometryReader { proxy in
            let size = proxy.size
            
            let showRes = viewModel.checkRes != .checking
            let spaceWidth: Double = (showRes && viewModel.megeGrid) ? 0 : 1
            
            let itemWidth = (size.width - Double(viewModel.columns - 1)) / Double(viewModel.columns)
            let itemHeight = (size.height - Double(viewModel.rows - 1)) / Double(viewModel.rows)
            
            let length = min(itemWidth, itemHeight)
            
            let top = (size.height - length * Double(viewModel.rows) - spaceWidth * Double((viewModel.rows - 1))) / 2
            let leading = (size.width - length * Double(viewModel.columns) - spaceWidth * Double((viewModel.columns - 1))) / 2

            Canvas { context, _ in
                func drawAt(row: Int, col: Int) {
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
                        let p1 = CGPointMake(rect.origin.x + length / 2, rect.origin.y + length)
                        let p2 = CGPointMake(rect.origin.x + length, rect.origin.y + length / 2)
                        let p3 = CGPointMake(rect.origin.x + length, rect.origin.y + length)
                        
                        var trangle = Path()
                        trangle.move(to: p1)
                        trangle.addLine(to: p2)
                        trangle.addLine(to: p3)
                        trangle.addLine(to: p1)
                        context.fill(trangle, with: .color(showRes ? .green : .red))
                        
                        var line = Path()
                        line.move(to: p1)
                        line.addLine(to: p2)
                        context.stroke(line, with: .color(.white), style: StrokeStyle(lineWidth: 1))
                        
                        let image = Image(systemName: showRes ? "checkmark" : "xmark")
                        
                        let imagePoint = CGPointMake(rect.origin.x + length * 7 / 8, rect.origin.y + length * 7 / 8)
                        
                        context.draw(image, at: imagePoint, anchor: .center)
                    }
                }
                
                if showRes && viewModel.megeGrid {
                    let rect = CGRectMake(leading, top, size.width - leading * 2, size.height - top * 2)
                    context.fill(Path(rect), with: .color(viewModel.color))
                    drawAt(row: viewModel.posy, col: viewModel.posx)
                } else {
                    for row in 0..<viewModel.rows {
                        for col in 0..<viewModel.columns {
                            drawAt(row: row, col: col)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onTapGesture { point in
                if viewModel.checkRes != .checking {
                    return
                }
                
                let x = Int(floor((point.x - leading) / (length + 1)))
                let y = Int(floor((point.y - top) / (length + 1)))
                
                viewModel.select(at: x, y: y)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .disabled(!begin)
    }
    
    @ViewBuilder
    func makeActionView(isHorizontal: Bool) -> some View {
        let checkButton = ActionButton(title: lCheckNameKey) {
            viewModel.showAnswer()
        }.disabled(viewModel.checkRes != .checking || !begin)
        
        let helpButton = ActionButton(title: lHelpNameKey) {
            showInfo = true
        }
        
        let nextButton = ActionButton(title: lNextNameKey) {
            viewModel.general()
        }
        
        let settingButton = ActionButton(title: lSettingNameKey) {
            showSetting = true
        }
        
        if isHorizontal {
            VStack {
                checkButton
                
                helpButton
                
                if begin {
                    nextButton
                } else {
                    ActionButton(title: lLocalizationBeginNameKey) {
                        begin = true
                        viewModel.general()
                    }
                }
                
                settingButton
            }
        } else {
            Grid(horizontalSpacing: 10, verticalSpacing: 10) {
                GridRow {
                    checkButton
                    
                    helpButton
                }
                
                GridRow {
                    if begin {
                        nextButton
                    } else {
                        ActionButton(title: lLocalizationBeginNameKey) {
                            begin = true
                            viewModel.general()
                        }
                    }
                    
                    settingButton
                }
            }
        }
    }
}

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
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(lTipsNameKey)
        }
        .onDisappear {
            confirmed = true
        }
    }
}

#Preview {
    ContentView()
}
