//
//  CheckResult.swift
//  MaxVision
//
//  Created by hujinyou on 2025/2/16.
//

import SwiftUI

enum CheckResult: String, Identifiable {
    /// 在选择的过程中的状态
    case checking
    /// 选择正确的状态
    case right
    /// 结束选择的状态，比如查看答案
    case finished
    
    var id: String { rawValue }
}
