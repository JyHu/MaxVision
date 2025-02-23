//
//  InfoView.swift
//  MaxVision
//
//  Created by hujinyou on 2025/2/15.
//

import SwiftUI

struct InfoView: View {
    let normalColorInfo: RGBInfo?
    let quesColorInfo: RGBInfo?
    
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        NavigationStack {
            makeContent()
#if !os(macOS)
                .navigationTitle(lHelpNameKey)
                .navigationBarTitleDisplayMode(.inline)
#endif
        }
    }
    
    @ViewBuilder
    func makeContent() -> some View {
        if let normalColorInfo = normalColorInfo, let quesColorInfo = quesColorInfo {
            ScrollView {
                VStack {
                    MyGroupBox(lCurrentNameKey) {
                        Grid(horizontalSpacing: 0, verticalSpacing: 8) {
                            GridRow {
                                HStack {
                                    Spacer()
                                    
                                    Text(lNormalNameKey)
                                }
                                .padding(.trailing, 8)
                                
                                HStack {
                                    Text(lSpecialNameKey)
                                    
                                    Spacer()
                                }
                                .padding(.leading, 8)
                            }
                            .foregroundStyle(.secondary)
                            
                            GridRow {
                                HStack {
                                    Spacer()
                                    
                                    Text(normalColorInfo.hexString)
                                }
                                .padding(.trailing, 8)
                                
                                HStack {
                                    Text(quesColorInfo.hexString)
                                    
                                    Spacer()
                                }
                                .padding(.leading, 8)
                            }
                            .fontDesign(.monospaced)
                            
                            GridRow {
                                HStack {
                                    Spacer()
                                    
                                    Text(normalColorInfo.rgbString)
                                }
                                .padding(.trailing, 8)
                                
                                HStack {
                                    Text(quesColorInfo.rgbString)
                                    
                                    Spacer()
                                }
                                .padding(.leading, 8)
                            }
                            .fontDesign(.monospaced)
                        }
                        
                        HStack(spacing: 0) {
                            Rectangle()
                                .fill(normalColorInfo.color)
                                .frame(height: 120)
                                .frame(maxWidth: .infinity)
                            
                            Rectangle()
                                .fill(quesColorInfo.color)
                                .frame(height: 120)
                                .frame(maxWidth: .infinity)
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    
                    Spacer().frame(height: 20)
                    
                    makeToggleBox(lAutoNextNameKey, value: $viewModel.autoNext, tips: lAutoNextTipsNameKey)
                    
                    /// 在显示答案时，将所有网格合并为一个整体，去除中间的分割线，以便更直观地查看和对比结果。
                    makeToggleBox(lMergeGridNameKey, value: $viewModel.megeGrid, tips: lMergeGridTipsNameKey)
                    
                    /// 增加对比度是指在色值达到一定范围后，调整背景色，以增强色块与背景的对比度，从而提升辨识度。具体计算方法如下：累加 RGB 各通道的数值总和，并进行判断——如果总和小于 200，则背景色设为白色；如果大于 565，则背景色设为黑色；否则，背景色将根据系统的深色或浅色模式自动适配。
                    makeToggleBox(lIncreaseContrastNameKey, value: $viewModel.increaseContrast, tips: lContrastTipsNameKey)
                    
                    HStack {
                        Text(lLocalizationFirstTipsNameKey)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 18)
                    .padding(.vertical, 20)
                }
                .padding(.horizontal, 18)
            }
        } else {
            VStack {
                Text("No Info")
                    .font(.title)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    @ViewBuilder
    func makeToggleBox(_ title: LocalizedStringKey, value: Binding<Bool>, tips: LocalizedStringKey) -> some View {
        MyGroupBox {
            HStack {
                Text(title)
                
                Spacer()
                
                Toggle("", isOn: value).labelsHidden()
            }
            
            HStack {
                /// 在显示答案时，将所有网格合并为一个整体，去除中间的分割线，以便更直观地查看和对比结果。
                Text(tips)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Spacer()
            }
        }
    }
}
