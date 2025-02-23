//
//  ObservedRange.swift
//  MaxVision
//
//  Created by hujinyou on 2025/2/16.
//

import SwiftUI

class ObservedRange: ObservableObject, Equatable {
    static func == (lhs: ObservedRange, rhs: ObservedRange) -> Bool {
        lhs.minV == rhs.minV && lhs.maxV == rhs.maxV
    }
    
    @Published var minV: Int = 0
    @Published var maxV: Int = 255
}

