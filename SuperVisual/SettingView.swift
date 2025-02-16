//
//  SettingView.swift
//  SuperVisual
//
//  Created by hujinyou on 2025/2/15.
//

import SwiftUI

struct SettingView: View {
    @ObservedObject private var tmpModel: BaseModel
    
    @ObservedObject private var viewModel: ViewModel
    
    @Environment(\.dismiss) var dismissAction
    
    init(viewModel: ViewModel) {
        self.tmpModel = BaseModel(model: viewModel)
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 10) {
                    makeConfigBox("RGB Range", tips: "The value range of the RGB channels is used for generating random colors, with each channel ranging from 0 to 255.") {
                        SliderRow(.R, value: tmpModel.obR, viewModel: tmpModel).padding(.top, 10)
                        SliderRow(.G, value: tmpModel.obG, viewModel: tmpModel)
                        SliderRow(.B, value: tmpModel.obB, viewModel: tmpModel)
                    }
                    
                    makeConfigBox("RGB Offset", tips: "When generating random colors, a random offset of 0–20 is applied to one or more RGB channels to create unique color effects.") {
                        makeRGBRow(.R, value: $tmpModel.rf)
                        makeRGBRow(.G, value: $tmpModel.gf)
                        makeRGBRow(.B, value: $tmpModel.bf)
                    }
                    
                    makeConfigBox("Grid", tips: "The number of rows and columns in the grid, the value range is 4~10") {
                        makeGridRow("Rows", value: $tmpModel.rows)
                        makeGridRow("Columns", value: $tmpModel.columns)
                    }
                    
                    
                    
                    makeToggleBox("Auto Next", value: $viewModel.autoNext, tips: "Automatically switch to the next question after answering")
                    
                    /// 在显示答案时，将所有网格合并为一个整体，去除中间的分割线，以便更直观地查看和对比结果。
                    makeToggleBox("Meger Grid", value: $viewModel.megeGrid, tips: "When displaying the answer, merge all grids into a single entity and remove the dividing lines in between for a clearer and more intuitive comparison of the results.")
                    
                    /// 增加对比度是指在色值达到一定范围后，调整背景色，以增强色块与背景的对比度，从而提升辨识度。具体计算方法如下：累加 RGB 各通道的数值总和，并进行判断——如果总和小于 200，则背景色设为白色；如果大于 565，则背景色设为黑色；否则，背景色将根据系统的深色或浅色模式自动适配。
                    makeToggleBox("Increase the contrast", value: $viewModel.increaseContrast, tips: "Increasing contrast refers to adjusting the background color when the color value reaches a certain range to enhance the contrast between the color block and the background, thereby improving distinguishability. The specific calculation method is as follows: sum the values of the RGB channels and make a judgment—if the total is less than 200, the background color is set to white; if it is greater than 565, the background color is set to black; otherwise, the background color adapts automatically based on the system’s light or dark mode.")
                    
                    /// 撑起底部的距离
                    VStack { }.frame(height: 30)
                }
                .padding(.horizontal, 18)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Setting")
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button {
                        viewModel.merge(from: tmpModel)
                        dismissAction()
                    } label: {
                        Text("Save")
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(width: 240, height: 44)
                            .background(.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func makeConfigBox(_ title: String, tips: String, @ViewBuilder content: () -> some View) -> some View {
        GroupBox(title) {
            content()
            
            HStack {
                Text(tips)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Spacer()
            }
        }
    }
    
    @ViewBuilder
    func makeToggleBox(_ title: String, value: Binding<Bool>, tips: String) -> some View {
        GroupBox {
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
    
    @ViewBuilder
    func makeRGBRow(_ component: RGBComponent, value: Binding<Int>) -> some View {
        HStack {
            let isChecked = tmpModel.selectedOffsets.contains(component)
            
            Button {
                if isChecked {
                    if tmpModel.selectedOffsets.count > 1 {
                        tmpModel.selectedOffsets.remove(component)
                    }
                } else {
                    tmpModel.selectedOffsets.insert(component)
                }
            } label: {
                Image(systemName: isChecked ? "checkmark.circle" : "circle")
            }
            .frame(width: 30)
            
            Text(component.name)
            
            Spacer()
            
            Text("\(value.wrappedValue)")
                .fontDesign(.monospaced)
            
            Stepper("", value: value, in: 0...20, step: 1).labelsHidden()
        }
    }
    
    @ViewBuilder
    func makeGridRow(_ title: String, value: Binding<Int>) -> some View {
        HStack {
            Text(title)
            
            Spacer()
            
            Text("\(value.wrappedValue)")
                .fontDesign(.monospaced)

            Stepper("", value: value, in: 4...10, step: 1).labelsHidden()
        }
    }
}

private struct SliderRow: View {
    let component: RGBComponent
    
    @ObservedObject var value: ObservedRange
    
    @ObservedObject var viewModel: BaseModel
    
    init(_ component: RGBComponent, value: ObservedRange, viewModel: BaseModel) {
        self.component = component
        self.value = value
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(component.name)
                
                Spacer()
                
                Text("\(value.minV) ~ \(value.maxV)")
                    .fontDesign(.monospaced)
            }
            
            RangeSlider(value: value)
        }
    }
}
