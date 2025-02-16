//
//  SettingModel.swift
//  SuperVisual
//
//  Created by hujinyou on 2025/2/16.
//

import SwiftUI

class SettingViewModel: ObservableObject {
    @Published var rf: Int = 10
    @Published var gf: Int = 10
    @Published var bf: Int = 10
    
    @Published var obR = ObservedRange()
    @Published var obG = ObservedRange()
    @Published var obB = ObservedRange()
    
    @Published var selectedOffsets: Set<RGBComponent> = [.R, .G, .B]
    
    @Published var rows: Int = 5
    @Published var columns: Int = 5
            
    init() { }
    
    init(model: ViewModel) {
        self.rf = model.rf
        self.gf = model.gf
        self.bf = model.bf
        
        self.obR = model.obR
        self.obG = model.obG
        self.obB = model.obB
        
        self.selectedOffsets = model.selectedOffsets
        
        self.rows = model.rows
        self.columns = model.columns
    }
}
