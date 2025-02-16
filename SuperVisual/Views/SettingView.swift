//
//  SettingView.swift
//  SuperVisual
//
//  Created by hujinyou on 2025/2/15.
//

import SwiftUI

struct SettingView: View {
    @ObservedObject private var tmpModel: SettingViewModel
    
    @ObservedObject private var viewModel: ViewModel
    
    @Environment(\.dismiss) var dismissAction
    
    @EnvironmentObject var languageManager: LanguageManager
    @State private var titleValue: String = "Setting"
            
    init(viewModel: ViewModel) {
        self.tmpModel = SettingViewModel(model: viewModel)
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 10) {
                    makeConfigBox(lRGBRangeNameKey, tips: lRGBRangeTipsNameKey) {
                        SliderRow(.R, value: tmpModel.obR, viewModel: tmpModel).padding(.top, 10)
                        SliderRow(.G, value: tmpModel.obG, viewModel: tmpModel)
                        SliderRow(.B, value: tmpModel.obB, viewModel: tmpModel)
                    }
                    
                    makeConfigBox(lRGBOffsetNameKey, tips: lRGBOffsetTipsNameKey) {
                        makeRGBRow(.R, value: $tmpModel.rf)
                        makeRGBRow(.G, value: $tmpModel.gf)
                        makeRGBRow(.B, value: $tmpModel.bf)
                    }
                    
                    makeConfigBox(lGridNameKey, tips: lGridTipsNameKey) {
                        makeGridRow(lGridRowsNameKey, value: $tmpModel.rows)
                        makeGridRow(lGridColumnsNameKey, value: $tmpModel.columns)
                    }
                    
                    GroupBox {
                        HStack {
                            Text(lLanguageNameKey)
                            Spacer()
                            Picker("", selection: $languageManager.language) {
                                ForEach(Language.allCases, id: \.self) {
                                    Text($0.displayName).tag($0)
                                }
                            }.labelsHidden()
                        }
                    }
                    
                    /// 撑起底部的距离
                    VStack { }.frame(height: 30)
                }
                .padding(.horizontal, 18)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(titleValue)
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button {
                        viewModel.merge(from: tmpModel)
                        dismissAction()
                    } label: {
                        Text(lSaveNameKey)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(width: 240, height: 44)
                            .background(.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
            }
            .onChange(of: languageManager.locale) { _, _ in
                titleValue = languageManager.language.settingName
            }
            .onAppear {
                titleValue = languageManager.language.settingName
            }
        }
    }
    
    @ViewBuilder
    func makeConfigBox(_ title: LocalizedStringKey, tips: LocalizedStringKey, @ViewBuilder content: () -> some View) -> some View {
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
    func makeGridRow(_ title: LocalizedStringKey, value: Binding<Int>) -> some View {
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
    
    @ObservedObject var viewModel: SettingViewModel
    
    init(_ component: RGBComponent, value: ObservedRange, viewModel: SettingViewModel) {
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
