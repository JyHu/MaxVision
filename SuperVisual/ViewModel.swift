//
//  ViewModel.swift
//  SuperVisual
//
//  Created by hujinyou on 2025/2/14.
//

import SwiftUI

enum RGBComponent: String, Identifiable, CaseIterable {
    case R
    case G
    case B
    
    var id: String { rawValue }
    
    var name: String {
        switch self {
        case .R: "Red"
        case .G: "Green"
        case .B: "Blue"
        }
    }
}

struct RGBInfo {
    let red: Int
    let green: Int
    let blue: Int
    
    var color: Color {
        Color(red: Double(red) / 255, green: Double(green) / 255, blue: Double(blue) / 255)
    }
}

enum CheckResult: String, Identifiable {
    /// 在选择的过程中的状态
    case checking
    /// 选择正确的状态
    case right
    /// 结束选择的状态，比如查看答案
    case finished
    
    var id: String { rawValue }
}

enum BGType {
    case light
    case dark
    
    var color: Color {
        switch self {
            case .light: return Color.white
            case .dark: return Color.black
        }
    }
}

class ObservedRange: ObservableObject, Equatable {
    static func == (lhs: ObservedRange, rhs: ObservedRange) -> Bool {
        lhs.minV == rhs.minV && lhs.maxV == rhs.maxV
    }
    
    @Published var minV: Int = 0
    @Published var maxV: Int = 255
}

class BaseModel: ObservableObject {
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

class ViewModel: ObservableObject {
    
    /// ----------------------------------
    /// 设置数据
    
    @Published var rf: Int = 10
    @Published var gf: Int = 10
    @Published var bf: Int = 10
    
    @Published var obR = ObservedRange()
    @Published var obG = ObservedRange()
    @Published var obB = ObservedRange()
    
    @Published var selectedOffsets: Set<RGBComponent> = [.R, .G, .B]
    
    @Published var rows: Int = 5
    @Published var columns: Int = 5
    
    @Published var autoNext: Bool = false {
        didSet {
            UserDefaults.standard.set(autoNext, forKey: "com.auu.autoNext")
            UserDefaults.standard.synchronize()
        }
    }
    
    @Published var megeGrid: Bool = false {
        didSet {
            UserDefaults.standard.set(megeGrid, forKey: "com.auu.megeGrid")
            UserDefaults.standard.synchronize()
        }
    }
    
    @Published var increaseContrast: Bool = false {
        didSet {
            UserDefaults.standard.set(increaseContrast, forKey: "com.auu.increaseContrast")
            UserDefaults.standard.synchronize()
        }
    }
    
    /// --------------------------
    /// 计算数据
    
    @Published var color: Color = .red
    @Published var quesColor: Color = .red
    
    @Published var posx: Int = 1
    @Published var posy: Int = 1
    
    @Published var selectedX: Int?
    @Published var selectedY: Int?
    @Published var checkRes: CheckResult = .checking
    
    @Published var normalColorInfo: RGBInfo?
    @Published var quesColorInfo: RGBInfo?
    
    @Published var bgType: BGType?
    
    private var nextAction: DispatchWorkItem?
    
    init() {
        self.autoNext = UserDefaults.standard.bool(forKey: "com.auu.autoNext")
        self.megeGrid = UserDefaults.standard.bool(forKey: "com.auu.megeGrid")
        self.increaseContrast = UserDefaults.standard.bool(forKey: "com.auu.increaseContrast")
        self.loadCachedConfigs()
        
        general()
    }
    
    func merge(from model: BaseModel) {
        let changed =
            self.rf != model.rf ||
            self.gf != model.gf ||
            self.bf != model.bf ||
            self.obR != model.obR ||
            self.obG != model.obG ||
            self.obB != model.obB ||
            self.rows != model.rows ||
            self.columns != model.columns ||
            self.selectedOffsets != model.selectedOffsets
        
        self.rf = model.rf
        self.gf = model.gf
        self.bf = model.bf
        
        self.obR = model.obR
        self.obG = model.obG
        self.obB = model.obB
        
        self.selectedOffsets = model.selectedOffsets
        
        self.rows = model.rows
        self.columns = model.columns
        
        self.cacheConfigs()
        
        if changed {
            general()
        }
    }
    
    func general() {
        self.nextAction?.cancel()
        self.nextAction = nil
        
        func random(offset: Int, component: RGBComponent, range: ObservedRange) -> (original: Int, offseted: Int) {
            let val = Int.random(in: range.minV...range.maxV)
            
            if offset == 0 || !selectedOffsets.contains(component) {
                return (val, val)
            }
            
            if Bool.random() {
                if val + offset > 255 {
                    return (val, val - offset)
                } else {
                    return (val, val + offset)
                }
            } else {
                if val - offset < 0 {
                    return (val, val + offset)
                } else {
                    return (val, val - offset)
                }
            }
        }
        
        let r = random(offset: rf, component: .R, range: obR)
        let g = random(offset: gf, component: .G, range: obG)
        let b = random(offset: bf, component: .B, range: obB)
        
        self.normalColorInfo = RGBInfo(red: r.original, green: g.original, blue: b.original)
        self.quesColorInfo = RGBInfo(red: r.offseted, green: g.offseted, blue: b.offseted)
        
        if let color = self.normalColorInfo?.color {
            self.color = color
        }
        
        if let color = self.quesColorInfo?.color {
            self.quesColor = color
        }
        
        self.posx = Int.random(in: 0..<columns)
        self.posy = Int.random(in: 0..<rows)
        
        self.selectedX = nil
        self.selectedY = nil
        self.checkRes = .checking
        
        let totalVal = r.original + g.original + b.original
        if totalVal < 200 {
            bgType = .light
        } else if totalVal > 565 {
            bgType = .dark
        } else {
            bgType = nil
        }
    }
    
    func select(at x: Int, y: Int) {
        if x == posx && y == posy {
            checkRes = .right
            
            if autoNext {
                let item = DispatchWorkItem {
                    self.general()
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: item)
                
                self.nextAction = item
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                self.selectedX = nil
                self.selectedY = nil
            }
        }
        
        self.selectedX = x
        self.selectedY = y
    }
    
    func showAnswer() {
        self.selectedX = posx
        self.selectedY = posy
        self.checkRes = .finished
    }
    
    func cacheConfigs() {
        var configs: [String: Any] = [:]
        configs["rf"] = rf
        configs["gf"] = gf
        configs["bf"] = bf
        
        configs["obR"] = [
            "min": obR.minV,
            "max": obR.maxV
        ]
        
        configs["obG"] = [
            "min": obG.minV,
            "max": obG.maxV
        ]
        
        configs["obB"] = [
            "min": obB.minV,
            "max": obB.maxV
        ]
        
        configs["selectedOffsets"] = selectedOffsets.map { $0.rawValue }
        
        configs["rows"] = rows
        configs["columns"] = columns
        
        UserDefaults.standard.set(configs, forKey: "com.auu.configs")
        UserDefaults.standard.synchronize()
    }
    
    func loadCachedConfigs() {
        guard let configs = UserDefaults.standard.dictionary(forKey: "com.auu.configs") else {
            return
        }
        
        if let rf = configs["rf"] as? Int {
            self.rf = rf
        }
        
        if let gf = configs["gf"] as? Int {
            self.gf = gf
        }
        
        if let bf = configs["bf"] as? Int {
            self.bf = bf
        }
        
        if let obR = configs["obR"] as? [String: Int] {
            self.obR.minV = obR["min"] ?? 0
            self.obR.maxV = obR["max"] ?? 255
        }
        
        if let obG = configs["obG"] as? [String: Int] {
            self.obG.minV = obG["min"] ?? 0
            self.obG.maxV = obG["max"] ?? 255
        }
        
        if let obB = configs["obB"] as? [String: Int] {
            self.obB.minV = obB["min"] ?? 0
            self.obB.maxV = obB["max"] ?? 255
        }
        
        if let selectedOffsets = configs["selectedOffsets"] as? [String] {
            self.selectedOffsets = Set(selectedOffsets.compactMap { RGBComponent(rawValue: $0) })
        }
        
        if let rows = configs["rows"] as? Int {
            self.rows = rows
        }
        
        if let columns = configs["columns"] as? Int {
            self.columns = columns
        }
    }
}
