//
//  SliderView.swift
//  MaxVision
//
//  Created by hujinyou on 2025/2/15.
//

import SwiftUI

enum SquareSide {
    case left
    case right
}

struct RangeSlider: View {
    @ObservedObject var value: ObservedRange
    
    let range: ClosedRange<Int>
    
    @State private var squareSide: SquareSide?
    
    init(value: ObservedRange, range: ClosedRange<Int> = 0...255) {
        self.value = value
        self.range = range
    }
    
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            
            /// 滑动条的高度
            let sliderHeight = size.height / 3
            /// 滑动条的弧度
            let sliderRadius = sliderHeight / 2
            /// 滑动条的y坐标
            let sliderY = (size.height - sliderHeight) / 2
            
            /// 滑块的宽高，圆形
            let squareSize = size.height
            
            let squareRadius = squareSize / 2
            
            /// 滑动条显示的数值范围
            let sliderMax = range.upperBound - range.lowerBound
            
            /// 将range数值范围映射到滑动条
            /// 滑块的宽度不算
            let step = (size.width - squareSize * 2) / CGFloat(sliderMax)
            
            let leftSquareX = calcX(value.minV, step: step)
            let rightSquareX = calcX(value.maxV, step: step) + squareSize
            
            ///
            ///
            ///         ╭────╮                     ╭────╮╌╌╌╌╌╌╌╌╌╌╌╌╌ m
            ///   ╭╴────╯    ╰─────────────────────╯    ╰─────╮╌╌╌╌╌╌╌ n
            ///   ╰─────╮    ╭─────────────────────╮    ╭─────╯╌╌╌╌╌╌╌ p
            ///   ┆     ╰────╯                     ╰────╯╌╌╌╌╌┆╌╌╌╌╌╌╌ q
            ///   ┆     ┆    ┆                     ┆    ┆     ┆
            ///   ┆     ┆    ┆                     ┆    ┆     ┆
            ///   ┆     ┆    ┆                     ┆    ┆     ┆
            ///   a     b    c                     d    e     f
            ///
            ///  a: 滑动条的最左侧，表示最小值，即range.lowerBound
            ///  f: 滑动条的最右侧，表示最大值，即range.upperBound
            ///
            ///  b-c: 左侧的滑块
            ///  d-e: 右侧的滑块
            ///
            ///  b: 左侧滑块的x坐标位置，即leftSquareX
            ///  d: 右侧滑块的x坐标位置，即rightSquareX
            ///
            ///  ab + cd + ef: 实际有效的滑动数值区间，滑块区域的宽度不计算
            ///
            
            Canvas { context, _ in
                /// 绘制滑条背景
                context.fill(Path(roundedRect: CGRect(x: 0, y: sliderY, width: size.width, height: sliderHeight), cornerRadius: sliderRadius), with: .color(.gray.opacity(0.6)))
                
                /// 绘制选中区间
                context.fill(Path(CGRect(x: leftSquareX + squareRadius, y: sliderY, width: rightSquareX - leftSquareX, height: sliderHeight)), with: .color(.blue))
                
                /// 绘制左侧滑块
                context.fill(Path(ellipseIn: CGRect(x: leftSquareX, y: 0, width: squareSize, height: squareSize)), with: .color(.white))
                
                /// 绘制右侧滑块
                context.fill(Path(ellipseIn: CGRect(x: rightSquareX, y: 0, width: squareSize, height: squareSize)), with: .color(.white))
            }
            .frame(width: size.width, height: size.height)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        let location = value.location

                        if let squareSide {
                            if squareSide == .left {
                                let newV = Int(location.x / step)
                                
                                if newV < 0 {
                                    self.value.minV = range.lowerBound
                                } else if newV > sliderMax {
                                    self.value.minV = range.upperBound
                                } else {
                                    self.value.minV = newV + range.lowerBound
                                }
                                
                                if self.value.minV > self.value.maxV {
                                    self.value.maxV = self.value.minV
                                }
                            } else {
                                let newV = Int((location.x - squareSize) / step)
                                
                                if newV < 0 {
                                    self.value.maxV = range.lowerBound
                                } else if newV > sliderMax {
                                    self.value.maxV = range.upperBound
                                } else {
                                    self.value.maxV = newV + range.lowerBound
                                }
                                
                                if self.value.minV > self.value.maxV {
                                    self.value.minV = self.value.maxV
                                }
                            }
                        } else {
                            if location.x > leftSquareX && location.x < leftSquareX + squareSize {
                                self.squareSide = .left
                            } else if location.x > rightSquareX && location.x < rightSquareX + squareSize {
                                self.squareSide = .right
                            }
                        }
                    }
                    .onEnded { value in
                        squareSide = nil
                    }
            )
        }
        .frame(height: 24)
    }
}

private extension RangeSlider {
    func calcX(_ value: Int, step: CGFloat) -> CGFloat {
        let validValue = min(max(range.lowerBound, value), range.upperBound)
        return CGFloat(validValue - range.lowerBound) * step
    }
}
