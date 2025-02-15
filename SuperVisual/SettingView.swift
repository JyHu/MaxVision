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
                    GroupBox("RGB Offset") {
                        makeRow(.R, value: $tmpModel.rf)
                        makeRow(.G, value: $tmpModel.gf)
                        makeRow(.B, value: $tmpModel.bf)
                    }
                    
                    GroupBox("RGB Range") {
                        SliderRow(.R, value: tmpModel.obR, viewModel: tmpModel)
                        SliderRow(.G, value: tmpModel.obG, viewModel: tmpModel)
                        SliderRow(.B, value: tmpModel.obB, viewModel: tmpModel)
                    }
                    
                    GroupBox("Grid") {
                        makeRow("Rows", value: $tmpModel.rows)
                        makeRow("Columns", value: $tmpModel.columns)
                    }
                    
                    GroupBox {
                        HStack {
                            Text("Auto Next")
                            Spacer()
                            Toggle("", isOn: $viewModel.autoNext).labelsHidden()
                        }
                    }
                    
                    Button {
                        viewModel.merge(from: tmpModel)
                        dismissAction()
                    } label: {
                        Text("Save")
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .background(.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .padding(.top, 20)
                }
                .padding(.horizontal, 18)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Setting")
        }
    }
    
    @ViewBuilder
    func makeRow(_ rgb: RGB, value: Binding<Int>) -> some View {
        HStack {
            let isChecked = tmpModel.selectedOffsets.contains(rgb)
            
            Button {
                if isChecked {
                    if tmpModel.selectedOffsets.count > 1 {
                        tmpModel.selectedOffsets.remove(rgb)
                    }
                } else {
                    tmpModel.selectedOffsets.insert(rgb)
                }
            } label: {
                Image(systemName: isChecked ? "checkmark.circle" : "circle")
            }
            .frame(width: 30)
            
            Text(rgb.name)
            
            Spacer()
            
            Stepper("", value: value, in: 0...20, step: 1).labelsHidden()
            
            Text("\(value.wrappedValue)")
                .frame(width: 60)
                .fontDesign(.monospaced)
        }
    }
    
    @ViewBuilder
    func makeRow(_ title: String, value: Binding<Int>) -> some View {
        HStack {
            Text(title)
            
            Spacer()
            
            Stepper("", value: value, in: 4...10, step: 1)
            
            Text("\(value.wrappedValue)")
                .frame(width: 60)
                .fontDesign(.monospaced)
        }
    }
}

private struct SliderRow: View {
    let rgb: RGB
    
    @ObservedObject var value: ObservedRange
    
    @ObservedObject var viewModel: BaseModel
    
    init(_ rgb: RGB, value: ObservedRange, viewModel: BaseModel) {
        self.rgb = rgb
        self.value = value
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(rgb.name)
                
                Spacer()
                
                Text("\(value.minV) ~ \(value.maxV)")
                    .fontDesign(.monospaced)
            }
            
            RangeSlider(value: value)
        }
    }
}
