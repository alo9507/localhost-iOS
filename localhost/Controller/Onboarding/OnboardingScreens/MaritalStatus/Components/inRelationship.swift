//
//  married.swift
//  Contact
//
//  Created by Andrew O'Brien on 1/11/20.
//  Copyright © 2020 Andrew O'Brien. All rights reserved.
//

import Foundation
import UIKit

class inRelationship: NiblessView {
    var isSelected: Bool = false {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
    }
    
    let targetFrame: CGRect = CGRect(x: 0, y: 0, width: 120, height: 120)
    let resizing: LocalhostStyleKit.ResizingBehavior = .aspectFit
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()!
        
        /// Resize to Target Frame
        context.saveGState()
        let resizedFrame = resizing.apply(rect: CGRect(x: 0, y: 0, width: 120, height: 120), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 120, y: resizedFrame.height / 120)
        
        /// relationship
        do {
            context.saveGState()
            context.translateBy(x: 1, y: 0)
            
            /// Oval
            let oval = UIBezierPath()
            oval.move(to: CGPoint(x: 2, y: 4))
            oval.addCurve(to: CGPoint(x: 4, y: 2), controlPoint1: CGPoint(x: 3.1, y: 4), controlPoint2: CGPoint(x: 4, y: 3.1))
            oval.addCurve(to: CGPoint(x: 2, y: 0), controlPoint1: CGPoint(x: 4, y: 0.9), controlPoint2: CGPoint(x: 3.1, y: 0))
            oval.addCurve(to: CGPoint(x: 0, y: 2), controlPoint1: CGPoint(x: 0.9, y: 0), controlPoint2: CGPoint(x: 0, y: 0.9))
            oval.addCurve(to: CGPoint(x: 2, y: 4), controlPoint1: CGPoint(x: 0, y: 3.1), controlPoint2: CGPoint(x: 0.9, y: 4))
            oval.close()
            context.saveGState()
            context.translateBy(x: 66, y: 24)
            if isSelected {
                UIColor.lhTurquoise.setFill()
            } else {
                UIColor.white.setFill()
            }
            oval.fill()
            context.restoreGState()
            
            /// Group
            do {
                context.saveGState()
                
                /// Shape
                let shape = UIBezierPath()
                shape.move(to: CGPoint(x: 93.21, y: 52.09))
                shape.addCurve(to: CGPoint(x: 104.28, y: 29.27), controlPoint1: CGPoint(x: 100.06, y: 46.68), controlPoint2: CGPoint(x: 104.28, y: 38.24))
                shape.addCurve(to: CGPoint(x: 75.01, y: 0), controlPoint1: CGPoint(x: 104.28, y: 13.19), controlPoint2: CGPoint(x: 91.23, y: 0))
                shape.addCurve(to: CGPoint(x: 51.54, y: 11.87), controlPoint1: CGPoint(x: 65.64, y: 0), controlPoint2: CGPoint(x: 57.07, y: 4.35))
                shape.addCurve(to: CGPoint(x: 32.28, y: 4.62), controlPoint1: CGPoint(x: 46.39, y: 7.38), controlPoint2: CGPoint(x: 39.67, y: 4.62))
                shape.addCurve(to: CGPoint(x: 3.01, y: 33.89), controlPoint1: CGPoint(x: 16.19, y: 4.62), controlPoint2: CGPoint(x: 3.01, y: 17.67))
                shape.addCurve(to: CGPoint(x: 7.89, y: 49.98), controlPoint1: CGPoint(x: 3.01, y: 39.82), controlPoint2: CGPoint(x: 4.72, y: 45.36))
                shape.addLine(to: CGPoint(x: 7.62, y: 50.24))
                shape.addCurve(to: CGPoint(x: 0.37, y: 63.16), controlPoint1: CGPoint(x: 4.85, y: 52.35), controlPoint2: CGPoint(x: -1.61, y: 57.23))
                shape.addCurve(to: CGPoint(x: 4.19, y: 66.33), controlPoint1: CGPoint(x: 0.9, y: 64.88), controlPoint2: CGPoint(x: 2.22, y: 65.93))
                shape.addCurve(to: CGPoint(x: 6.17, y: 66.33), controlPoint1: CGPoint(x: 4.59, y: 66.46), controlPoint2: CGPoint(x: 5.91, y: 66.46))
                shape.addCurve(to: CGPoint(x: 3.27, y: 73.05), controlPoint1: CGPoint(x: 4.33, y: 69.63), controlPoint2: CGPoint(x: 3.4, y: 72.79))
                shape.addCurve(to: CGPoint(x: 4.72, y: 75.82), controlPoint1: CGPoint(x: 2.88, y: 74.24), controlPoint2: CGPoint(x: 3.67, y: 75.43))
                shape.addCurve(to: CGPoint(x: 5.38, y: 75.96), controlPoint1: CGPoint(x: 4.99, y: 75.82), controlPoint2: CGPoint(x: 5.12, y: 75.96))
                shape.addCurve(to: CGPoint(x: 7.49, y: 74.37), controlPoint1: CGPoint(x: 6.3, y: 75.96), controlPoint2: CGPoint(x: 7.23, y: 75.3))
                shape.addCurve(to: CGPoint(x: 13.29, y: 64.35), controlPoint1: CGPoint(x: 8.02, y: 72.4), controlPoint2: CGPoint(x: 10.26, y: 66.73))
                shape.addCurve(to: CGPoint(x: 19.36, y: 60), controlPoint1: CGPoint(x: 15.93, y: 63.16), controlPoint2: CGPoint(x: 18.17, y: 61.58))
                shape.addCurve(to: CGPoint(x: 25.03, y: 62.11), controlPoint1: CGPoint(x: 21.21, y: 60.92), controlPoint2: CGPoint(x: 23.05, y: 61.58))
                shape.addCurve(to: CGPoint(x: 25.56, y: 62.24), controlPoint1: CGPoint(x: 25.16, y: 62.11), controlPoint2: CGPoint(x: 25.43, y: 62.24))
                shape.addCurve(to: CGPoint(x: 27.67, y: 60.66), controlPoint1: CGPoint(x: 26.48, y: 62.24), controlPoint2: CGPoint(x: 27.4, y: 61.58))
                shape.addCurve(to: CGPoint(x: 26.08, y: 58.02), controlPoint1: CGPoint(x: 27.93, y: 59.47), controlPoint2: CGPoint(x: 27.27, y: 58.29))
                shape.addCurve(to: CGPoint(x: 7.49, y: 34.02), controlPoint1: CGPoint(x: 15.14, y: 55.12), controlPoint2: CGPoint(x: 7.49, y: 45.23))
                shape.addCurve(to: CGPoint(x: 32.28, y: 9.23), controlPoint1: CGPoint(x: 7.49, y: 20.31), controlPoint2: CGPoint(x: 18.57, y: 9.23))
                shape.addCurve(to: CGPoint(x: 57.07, y: 34.02), controlPoint1: CGPoint(x: 46, y: 9.23), controlPoint2: CGPoint(x: 57.07, y: 20.31))
                shape.addCurve(to: CGPoint(x: 42.3, y: 56.7), controlPoint1: CGPoint(x: 57.07, y: 43.78), controlPoint2: CGPoint(x: 51.27, y: 52.75))
                shape.addCurve(to: CGPoint(x: 41.25, y: 59.6), controlPoint1: CGPoint(x: 41.25, y: 57.23), controlPoint2: CGPoint(x: 40.72, y: 58.55))
                shape.addCurve(to: CGPoint(x: 44.15, y: 60.66), controlPoint1: CGPoint(x: 41.78, y: 60.66), controlPoint2: CGPoint(x: 43.1, y: 61.19))
                shape.addCurve(to: CGPoint(x: 46.66, y: 59.34), controlPoint1: CGPoint(x: 44.94, y: 60.26), controlPoint2: CGPoint(x: 45.86, y: 59.87))
                shape.addCurve(to: CGPoint(x: 59.18, y: 74.64), controlPoint1: CGPoint(x: 51.54, y: 62.24), controlPoint2: CGPoint(x: 56.15, y: 67.78))
                shape.addCurve(to: CGPoint(x: 61.16, y: 75.96), controlPoint1: CGPoint(x: 59.58, y: 75.43), controlPoint2: CGPoint(x: 60.37, y: 75.96))
                shape.addCurve(to: CGPoint(x: 62.08, y: 75.82), controlPoint1: CGPoint(x: 61.43, y: 75.96), controlPoint2: CGPoint(x: 61.82, y: 75.96))
                shape.addCurve(to: CGPoint(x: 63.14, y: 72.92), controlPoint1: CGPoint(x: 63.14, y: 75.3), controlPoint2: CGPoint(x: 63.67, y: 73.98))
                shape.addCurve(to: CGPoint(x: 50.61, y: 56.84), controlPoint1: CGPoint(x: 60.11, y: 66.07), controlPoint2: CGPoint(x: 55.49, y: 60.26))
                shape.addCurve(to: CGPoint(x: 55.75, y: 51.43), controlPoint1: CGPoint(x: 52.59, y: 55.25), controlPoint2: CGPoint(x: 54.3, y: 53.41))
                shape.addCurve(to: CGPoint(x: 67.62, y: 57.76), controlPoint1: CGPoint(x: 59.18, y: 54.46), controlPoint2: CGPoint(x: 63.14, y: 56.57))
                shape.addCurve(to: CGPoint(x: 68.15, y: 57.89), controlPoint1: CGPoint(x: 67.75, y: 57.76), controlPoint2: CGPoint(x: 68.02, y: 57.89))
                shape.addCurve(to: CGPoint(x: 70.26, y: 56.31), controlPoint1: CGPoint(x: 69.07, y: 57.89), controlPoint2: CGPoint(x: 70, y: 57.23))
                shape.addCurve(to: CGPoint(x: 68.68, y: 53.67), controlPoint1: CGPoint(x: 70.52, y: 55.12), controlPoint2: CGPoint(x: 69.86, y: 53.93))
                shape.addCurve(to: CGPoint(x: 58.13, y: 47.87), controlPoint1: CGPoint(x: 64.72, y: 52.62), controlPoint2: CGPoint(x: 61.16, y: 50.64))
                shape.addCurve(to: CGPoint(x: 61.43, y: 34.29), controlPoint1: CGPoint(x: 60.24, y: 43.78), controlPoint2: CGPoint(x: 61.43, y: 39.16))
                shape.addCurve(to: CGPoint(x: 54.57, y: 15.43), controlPoint1: CGPoint(x: 61.43, y: 27.16), controlPoint2: CGPoint(x: 58.79, y: 20.57))
                shape.addCurve(to: CGPoint(x: 74.88, y: 4.75), controlPoint1: CGPoint(x: 59.18, y: 8.7), controlPoint2: CGPoint(x: 66.7, y: 4.75))
                shape.addCurve(to: CGPoint(x: 99.67, y: 29.54), controlPoint1: CGPoint(x: 88.59, y: 4.75), controlPoint2: CGPoint(x: 99.67, y: 15.82))
                shape.addCurve(to: CGPoint(x: 84.9, y: 52.22), controlPoint1: CGPoint(x: 99.67, y: 39.3), controlPoint2: CGPoint(x: 93.86, y: 48.26))
                shape.addCurve(to: CGPoint(x: 83.84, y: 55.12), controlPoint1: CGPoint(x: 83.84, y: 52.75), controlPoint2: CGPoint(x: 83.32, y: 54.07))
                shape.addCurve(to: CGPoint(x: 85.82, y: 56.44), controlPoint1: CGPoint(x: 84.24, y: 55.91), controlPoint2: CGPoint(x: 85.03, y: 56.44))
                shape.addCurve(to: CGPoint(x: 89.12, y: 54.99), controlPoint1: CGPoint(x: 86.08, y: 56.44), controlPoint2: CGPoint(x: 87.4, y: 55.91))
                shape.addCurve(to: CGPoint(x: 100.06, y: 71.87), controlPoint1: CGPoint(x: 95.32, y: 58.68), controlPoint2: CGPoint(x: 100.06, y: 71.87))
                shape.addCurve(to: CGPoint(x: 102.04, y: 73.19), controlPoint1: CGPoint(x: 100.46, y: 72.66), controlPoint2: CGPoint(x: 101.25, y: 73.19))
                shape.addCurve(to: CGPoint(x: 102.96, y: 73.05), controlPoint1: CGPoint(x: 102.3, y: 73.19), controlPoint2: CGPoint(x: 102.7, y: 73.19))
                shape.addCurve(to: CGPoint(x: 104.02, y: 70.15), controlPoint1: CGPoint(x: 104.02, y: 72.53), controlPoint2: CGPoint(x: 104.55, y: 71.21))
                shape.addCurve(to: CGPoint(x: 93.21, y: 52.09), controlPoint1: CGPoint(x: 104.28, y: 69.76), controlPoint2: CGPoint(x: 99.67, y: 56.7))
                shape.addLine(to: CGPoint(x: 93.21, y: 52.09))
                shape.close()
                shape.move(to: CGPoint(x: 10.66, y: 53.41))
                shape.addCurve(to: CGPoint(x: 15.4, y: 57.63), controlPoint1: CGPoint(x: 12.11, y: 54.99), controlPoint2: CGPoint(x: 13.69, y: 56.44))
                shape.addCurve(to: CGPoint(x: 4.46, y: 61.85), controlPoint1: CGPoint(x: 13.69, y: 59.34), controlPoint2: CGPoint(x: 6.96, y: 63.82))
                shape.addCurve(to: CGPoint(x: 10.66, y: 53.41), controlPoint1: CGPoint(x: 2.35, y: 59.87), controlPoint2: CGPoint(x: 10.66, y: 53.41))
                shape.close()
                context.saveGState()
                context.translateBy(x: 13.79, y: 43.65)
                if isSelected {
                    UIColor.lhTurquoise.setFill()
                } else {
                    UIColor.white.setFill()
                }
                shape.fill()
                context.restoreGState()
                
                /// Path
                let path = UIBezierPath()
                path.move(to: CGPoint(x: 15.11, y: 0.56))
                path.addCurve(to: CGPoint(x: 4.43, y: 0.56), controlPoint1: CGPoint(x: 9.7, y: 4.38), controlPoint2: CGPoint(x: 4.96, y: 1.08))
                path.addCurve(to: CGPoint(x: 0.61, y: 1.08), controlPoint1: CGPoint(x: 3.24, y: -0.37), controlPoint2: CGPoint(x: 1.53, y: -0.1))
                path.addCurve(to: CGPoint(x: 1, y: 4.91), controlPoint1: CGPoint(x: -0.32, y: 2.27), controlPoint2: CGPoint(x: -0.19, y: 3.98))
                path.addCurve(to: CGPoint(x: 9.7, y: 7.81), controlPoint1: CGPoint(x: 2.72, y: 6.23), controlPoint2: CGPoint(x: 5.88, y: 7.81))
                path.addCurve(to: CGPoint(x: 18.14, y: 5.04), controlPoint1: CGPoint(x: 12.34, y: 7.81), controlPoint2: CGPoint(x: 15.24, y: 7.02))
                path.addCurve(to: CGPoint(x: 18.8, y: 1.21), controlPoint1: CGPoint(x: 19.33, y: 4.12), controlPoint2: CGPoint(x: 19.73, y: 2.4))
                path.addCurve(to: CGPoint(x: 15.11, y: 0.56), controlPoint1: CGPoint(x: 17.88, y: 0.03), controlPoint2: CGPoint(x: 16.43, y: -0.37))
                path.close()
                context.saveGState()
                context.translateBy(x: 77.65, y: 71.84)
                if isSelected {
                    UIColor.lhTurquoise.setFill()
                } else {
                    UIColor.white.setFill()
                }
                path.fill()
                context.restoreGState()
                
                /// Path
                let path2 = UIBezierPath()
                path2.move(to: CGPoint(x: 6.46, y: 3.16))
                path2.addCurve(to: CGPoint(x: 3.16, y: 0), controlPoint1: CGPoint(x: 6.46, y: 1.45), controlPoint2: CGPoint(x: 5.01, y: 0))
                path2.addCurve(to: CGPoint(x: 0, y: 3.16), controlPoint1: CGPoint(x: 1.45, y: 0), controlPoint2: CGPoint(x: 0, y: 1.45))
                path2.addCurve(to: CGPoint(x: 3.16, y: 6.33), controlPoint1: CGPoint(x: 0, y: 5.01), controlPoint2: CGPoint(x: 1.45, y: 6.33))
                path2.addCurve(to: CGPoint(x: 6.46, y: 3.16), controlPoint1: CGPoint(x: 5.01, y: 6.46), controlPoint2: CGPoint(x: 6.46, y: 5.01))
                path2.close()
                context.saveGState()
                context.translateBy(x: 76.8, y: 59.74)
                if isSelected {
                    UIColor.lhTurquoise.setFill()
                } else {
                    UIColor.white.setFill()
                }
                path2.fill()
                context.restoreGState()
                
                /// Path
                let path3 = UIBezierPath()
                path3.move(to: CGPoint(x: 3.16, y: 0))
                path3.addCurve(to: CGPoint(x: 0, y: 3.16), controlPoint1: CGPoint(x: 1.45, y: 0), controlPoint2: CGPoint(x: 0, y: 1.45))
                path3.addCurve(to: CGPoint(x: 3.16, y: 6.33), controlPoint1: CGPoint(x: 0, y: 5.01), controlPoint2: CGPoint(x: 1.45, y: 6.33))
                path3.addCurve(to: CGPoint(x: 6.33, y: 3.16), controlPoint1: CGPoint(x: 4.88, y: 6.33), controlPoint2: CGPoint(x: 6.33, y: 4.88))
                path3.addCurve(to: CGPoint(x: 3.16, y: 0), controlPoint1: CGPoint(x: 6.46, y: 1.45), controlPoint2: CGPoint(x: 5.01, y: 0))
                path3.close()
                context.saveGState()
                context.translateBy(x: 91.7, y: 59.74)
                if isSelected {
                    UIColor.lhTurquoise.setFill()
                } else {
                    UIColor.white.setFill()
                }
                path3.fill()
                context.restoreGState()
                
                /// Path
                let path4 = UIBezierPath()
                path4.move(to: CGPoint(x: 8.09, y: 4.67))
                path4.addLine(to: CGPoint(x: 3.74, y: 0.58))
                path4.addCurve(to: CGPoint(x: 0.58, y: 0.71), controlPoint1: CGPoint(x: 2.82, y: -0.21), controlPoint2: CGPoint(x: 1.5, y: -0.21))
                path4.addCurve(to: CGPoint(x: 0.71, y: 3.87), controlPoint1: CGPoint(x: -0.21, y: 1.63), controlPoint2: CGPoint(x: -0.21, y: 2.95))
                path4.addLine(to: CGPoint(x: 5.19, y: 7.96))
                path4.addCurve(to: CGPoint(x: 6.64, y: 8.49), controlPoint1: CGPoint(x: 5.59, y: 8.36), controlPoint2: CGPoint(x: 6.12, y: 8.49))
                path4.addCurve(to: CGPoint(x: 8.23, y: 7.83), controlPoint1: CGPoint(x: 7.17, y: 8.49), controlPoint2: CGPoint(x: 7.83, y: 8.23))
                path4.addCurve(to: CGPoint(x: 8.09, y: 4.67), controlPoint1: CGPoint(x: 9.15, y: 6.91), controlPoint2: CGPoint(x: 9.02, y: 5.59))
                path4.close()
                context.saveGState()
                context.translateBy(x: 5.15, y: 78.54)
                if isSelected {
                    UIColor.lhTurquoise.setFill()
                } else {
                    UIColor.white.setFill()
                }
                path4.fill()
                context.restoreGState()
                
                /// Path
                let path5 = UIBezierPath()
                path5.move(to: CGPoint(x: 9.51, y: 1.07))
                path5.addCurve(to: CGPoint(x: 2.39, y: 0.01), controlPoint1: CGPoint(x: 7.13, y: 0.54), controlPoint2: CGPoint(x: 2.65, y: 0.01))
                path5.addCurve(to: CGPoint(x: 0.01, y: 1.99), controlPoint1: CGPoint(x: 1.2, y: -0.12), controlPoint2: CGPoint(x: 0.14, y: 0.8))
                path5.addCurve(to: CGPoint(x: 1.99, y: 4.36), controlPoint1: CGPoint(x: -0.12, y: 3.18), controlPoint2: CGPoint(x: 0.8, y: 4.23))
                path5.addCurve(to: CGPoint(x: 9.11, y: 5.42), controlPoint1: CGPoint(x: 1.99, y: 4.36), controlPoint2: CGPoint(x: 8.85, y: 5.42))
                path5.addCurve(to: CGPoint(x: 11.22, y: 3.7), controlPoint1: CGPoint(x: 10.17, y: 5.42), controlPoint2: CGPoint(x: 10.96, y: 4.76))
                path5.addCurve(to: CGPoint(x: 9.51, y: 1.07), controlPoint1: CGPoint(x: 11.49, y: 2.52), controlPoint2: CGPoint(x: 10.69, y: 1.33))
                path5.close()
                context.saveGState()
                context.translateBy(x: 0.04, y: 89.13)
                if isSelected {
                    UIColor.lhTurquoise.setFill()
                } else {
                    UIColor.white.setFill()
                }
                path5.fill()
                context.restoreGState()
                
                /// Path
                let path6 = UIBezierPath()
                path6.move(to: CGPoint(x: 6.4, y: 0.19))
                path6.addCurve(to: CGPoint(x: 1.39, y: 2.95), controlPoint1: CGPoint(x: 5.48, y: 0.58), controlPoint2: CGPoint(x: 2.18, y: 2.56))
                path6.addCurve(to: CGPoint(x: 0.2, y: 5.86), controlPoint1: CGPoint(x: 0.2, y: 3.48), controlPoint2: CGPoint(x: -0.32, y: 4.67))
                path6.addCurve(to: CGPoint(x: 2.18, y: 7.17), controlPoint1: CGPoint(x: 0.6, y: 6.65), controlPoint2: CGPoint(x: 1.39, y: 7.17))
                path6.addCurve(to: CGPoint(x: 2.97, y: 7.04), controlPoint1: CGPoint(x: 2.45, y: 7.17), controlPoint2: CGPoint(x: 2.71, y: 7.17))
                path6.addCurve(to: CGPoint(x: 8.12, y: 4.27), controlPoint1: CGPoint(x: 4.03, y: 6.65), controlPoint2: CGPoint(x: 7.46, y: 4.67))
                path6.addCurve(to: CGPoint(x: 9.17, y: 1.37), controlPoint1: CGPoint(x: 9.17, y: 3.75), controlPoint2: CGPoint(x: 9.7, y: 2.43))
                path6.addCurve(to: CGPoint(x: 6.4, y: 0.19), controlPoint1: CGPoint(x: 8.64, y: 0.32), controlPoint2: CGPoint(x: 7.46, y: -0.34))
                path6.close()
                context.saveGState()
                context.translateBy(x: 1.43, y: 98.72)
                if isSelected {
                    UIColor.lhTurquoise.setFill()
                } else {
                    UIColor.white.setFill()
                }
                path6.fill()
                context.restoreGState()
                
                /// Path
                let path7 = UIBezierPath()
                path7.move(to: CGPoint(x: 18.92, y: 1.21))
                path7.addCurve(to: CGPoint(x: 15.1, y: 0.56), controlPoint1: CGPoint(x: 18, y: 0.03), controlPoint2: CGPoint(x: 16.29, y: -0.37))
                path7.addCurve(to: CGPoint(x: 4.42, y: 0.56), controlPoint1: CGPoint(x: 9.69, y: 4.38), controlPoint2: CGPoint(x: 4.95, y: 1.08))
                path7.addCurve(to: CGPoint(x: 0.6, y: 1.08), controlPoint1: CGPoint(x: 3.23, y: -0.37), controlPoint2: CGPoint(x: 1.52, y: -0.1))
                path7.addCurve(to: CGPoint(x: 1.12, y: 4.91), controlPoint1: CGPoint(x: -0.33, y: 2.27), controlPoint2: CGPoint(x: -0.2, y: 3.98))
                path7.addCurve(to: CGPoint(x: 9.83, y: 7.81), controlPoint1: CGPoint(x: 2.84, y: 6.23), controlPoint2: CGPoint(x: 6, y: 7.81))
                path7.addCurve(to: CGPoint(x: 18.27, y: 5.04), controlPoint1: CGPoint(x: 12.46, y: 7.81), controlPoint2: CGPoint(x: 15.36, y: 7.02))
                path7.addCurve(to: CGPoint(x: 18.92, y: 1.21), controlPoint1: CGPoint(x: 19.45, y: 4.25), controlPoint2: CGPoint(x: 19.72, y: 2.53))
                path7.close()
                context.saveGState()
                context.translateBy(x: 42.05, y: 75.53)
                if isSelected {
                    UIColor.lhTurquoise.setFill()
                } else {
                    UIColor.white.setFill()
                }
                path7.fill()
                context.restoreGState()
                
                /// Oval
                let oval2 = UIBezierPath()
                oval2.move(to: CGPoint(x: 3.16, y: 6.33))
                oval2.addCurve(to: CGPoint(x: 6.33, y: 3.16), controlPoint1: CGPoint(x: 4.91, y: 6.33), controlPoint2: CGPoint(x: 6.33, y: 4.91))
                oval2.addCurve(to: CGPoint(x: 3.16, y: 0), controlPoint1: CGPoint(x: 6.33, y: 1.42), controlPoint2: CGPoint(x: 4.91, y: 0))
                oval2.addCurve(to: CGPoint(x: 0, y: 3.16), controlPoint1: CGPoint(x: 1.42, y: 0), controlPoint2: CGPoint(x: 0, y: 1.42))
                oval2.addCurve(to: CGPoint(x: 3.16, y: 6.33), controlPoint1: CGPoint(x: 0, y: 4.91), controlPoint2: CGPoint(x: 1.42, y: 6.33))
                oval2.close()
                context.saveGState()
                context.translateBy(x: 41.2, y: 63.56)
                if isSelected {
                    UIColor.lhTurquoise.setFill()
                } else {
                    UIColor.white.setFill()
                }
                oval2.fill()
                context.restoreGState()
                
                /// Path
                let path8 = UIBezierPath()
                path8.move(to: CGPoint(x: 6.46, y: 3.16))
                path8.addCurve(to: CGPoint(x: 3.3, y: 0), controlPoint1: CGPoint(x: 6.46, y: 1.45), controlPoint2: CGPoint(x: 5.01, y: 0))
                path8.addCurve(to: CGPoint(x: 0, y: 3.16), controlPoint1: CGPoint(x: 1.45, y: 0), controlPoint2: CGPoint(x: 0, y: 1.45))
                path8.addCurve(to: CGPoint(x: 3.3, y: 6.33), controlPoint1: CGPoint(x: 0, y: 4.88), controlPoint2: CGPoint(x: 1.45, y: 6.33))
                path8.addCurve(to: CGPoint(x: 6.46, y: 3.16), controlPoint1: CGPoint(x: 5.01, y: 6.33), controlPoint2: CGPoint(x: 6.46, y: 4.88))
                path8.close()
                context.saveGState()
                context.translateBy(x: 55.97, y: 63.56)
                if isSelected {
                    UIColor.lhTurquoise.setFill()
                } else {
                    UIColor.white.setFill()
                }
                path8.fill()
                context.restoreGState()
                
                /// Shape
                let shape2 = UIBezierPath()
                shape2.move(to: CGPoint(x: 36.97, y: 0))
                shape2.addCurve(to: CGPoint(x: 27.08, y: 4.09), controlPoint1: CGPoint(x: 33.28, y: 0), controlPoint2: CGPoint(x: 29.59, y: 1.45))
                shape2.addCurve(to: CGPoint(x: 26.03, y: 5.27), controlPoint1: CGPoint(x: 26.69, y: 4.48), controlPoint2: CGPoint(x: 26.42, y: 4.88))
                shape2.addCurve(to: CGPoint(x: 12.71, y: 0.26), controlPoint1: CGPoint(x: 22.86, y: 1.32), controlPoint2: CGPoint(x: 17.72, y: -0.66))
                shape2.addCurve(to: CGPoint(x: 2.69, y: 7.25), controlPoint1: CGPoint(x: 8.36, y: 1.05), controlPoint2: CGPoint(x: 5.06, y: 3.43))
                shape2.addCurve(to: CGPoint(x: 1.9, y: 22.95), controlPoint1: CGPoint(x: -0.61, y: 12.79), controlPoint2: CGPoint(x: -0.87, y: 18.07))
                shape2.addCurve(to: CGPoint(x: 7.7, y: 30.73), controlPoint1: CGPoint(x: 3.35, y: 25.58), controlPoint2: CGPoint(x: 5.19, y: 28.09))
                shape2.addCurve(to: CGPoint(x: 24.58, y: 45.1), controlPoint1: CGPoint(x: 12.18, y: 35.47), controlPoint2: CGPoint(x: 17.59, y: 40.09))
                shape2.addCurve(to: CGPoint(x: 26.03, y: 45.49), controlPoint1: CGPoint(x: 25.11, y: 45.36), controlPoint2: CGPoint(x: 25.5, y: 45.49))
                shape2.addCurve(to: CGPoint(x: 27.74, y: 44.84), controlPoint1: CGPoint(x: 26.95, y: 45.49), controlPoint2: CGPoint(x: 27.48, y: 45.1))
                shape2.addCurve(to: CGPoint(x: 43.17, y: 31.91), controlPoint1: CGPoint(x: 33.94, y: 40.35), controlPoint2: CGPoint(x: 38.95, y: 36.26))
                shape2.addCurve(to: CGPoint(x: 50.29, y: 22.68), controlPoint1: CGPoint(x: 45.54, y: 29.41), controlPoint2: CGPoint(x: 48.31, y: 26.37))
                shape2.addCurve(to: CGPoint(x: 52.14, y: 16.35), controlPoint1: CGPoint(x: 51.22, y: 20.97), controlPoint2: CGPoint(x: 52.14, y: 18.73))
                shape2.addCurve(to: CGPoint(x: 45.81, y: 3.16), controlPoint1: CGPoint(x: 52.01, y: 10.95), controlPoint2: CGPoint(x: 49.9, y: 6.46))
                shape2.addCurve(to: CGPoint(x: 36.97, y: 0), controlPoint1: CGPoint(x: 43.43, y: 1.05), controlPoint2: CGPoint(x: 40.27, y: 0))
                shape2.addLine(to: CGPoint(x: 36.97, y: 0))
                shape2.close()
                shape2.move(to: CGPoint(x: 47.79, y: 16.48))
                shape2.addCurve(to: CGPoint(x: 46.47, y: 20.7), controlPoint1: CGPoint(x: 47.79, y: 17.93), controlPoint2: CGPoint(x: 47.13, y: 19.38))
                shape2.addCurve(to: CGPoint(x: 40.01, y: 28.88), controlPoint1: CGPoint(x: 44.75, y: 24), controlPoint2: CGPoint(x: 42.25, y: 26.64))
                shape2.addCurve(to: CGPoint(x: 25.9, y: 40.75), controlPoint1: CGPoint(x: 36.05, y: 32.84), controlPoint2: CGPoint(x: 31.7, y: 36.66))
                shape2.addCurve(to: CGPoint(x: 10.73, y: 27.69), controlPoint1: CGPoint(x: 19.7, y: 36.26), controlPoint2: CGPoint(x: 14.82, y: 32.04))
                shape2.addCurve(to: CGPoint(x: 5.46, y: 20.7), controlPoint1: CGPoint(x: 8.49, y: 25.19), controlPoint2: CGPoint(x: 6.78, y: 23.08))
                shape2.addCurve(to: CGPoint(x: 6.12, y: 9.49), controlPoint1: CGPoint(x: 3.48, y: 17.14), controlPoint2: CGPoint(x: 3.61, y: 13.58))
                shape2.addCurve(to: CGPoint(x: 13.5, y: 4.48), controlPoint1: CGPoint(x: 8.09, y: 6.73), controlPoint2: CGPoint(x: 10.47, y: 5.14))
                shape2.addCurve(to: CGPoint(x: 15.22, y: 4.35), controlPoint1: CGPoint(x: 14.03, y: 4.48), controlPoint2: CGPoint(x: 14.69, y: 4.35))
                shape2.addCurve(to: CGPoint(x: 23.79, y: 9.76), controlPoint1: CGPoint(x: 18.78, y: 4.35), controlPoint2: CGPoint(x: 21.94, y: 6.33))
                shape2.addCurve(to: CGPoint(x: 24.05, y: 10.42), controlPoint1: CGPoint(x: 23.92, y: 9.89), controlPoint2: CGPoint(x: 23.92, y: 10.15))
                shape2.addCurve(to: CGPoint(x: 26.16, y: 11.6), controlPoint1: CGPoint(x: 24.58, y: 11.08), controlPoint2: CGPoint(x: 25.24, y: 11.47))
                shape2.addCurve(to: CGPoint(x: 28.14, y: 10.42), controlPoint1: CGPoint(x: 26.95, y: 11.6), controlPoint2: CGPoint(x: 27.74, y: 11.08))
                shape2.addCurve(to: CGPoint(x: 30.25, y: 7.25), controlPoint1: CGPoint(x: 28.8, y: 9.1), controlPoint2: CGPoint(x: 29.46, y: 8.18))
                shape2.addCurve(to: CGPoint(x: 37.11, y: 4.48), controlPoint1: CGPoint(x: 31.96, y: 5.54), controlPoint2: CGPoint(x: 34.47, y: 4.48))
                shape2.addCurve(to: CGPoint(x: 43.04, y: 6.59), controlPoint1: CGPoint(x: 39.35, y: 4.48), controlPoint2: CGPoint(x: 41.46, y: 5.27))
                shape2.addCurve(to: CGPoint(x: 47.79, y: 16.48), controlPoint1: CGPoint(x: 46.2, y: 9.1), controlPoint2: CGPoint(x: 47.65, y: 12.4))
                shape2.addLine(to: CGPoint(x: 47.79, y: 16.48))
                shape2.close()
                context.saveGState()
                context.translateBy(x: 33.1, y: 0.79)
                if isSelected {
                    UIColor.lhTurquoise.setFill()
                } else {
                    UIColor.white.setFill()
                }
                shape2.fill()
                context.restoreGState()
                
                /// Path
                let path9 = UIBezierPath()
                path9.move(to: CGPoint(x: 2.88, y: 0.12))
                path9.addCurve(to: CGPoint(x: 0.12, y: 1.57), controlPoint1: CGPoint(x: 1.7, y: -0.28), controlPoint2: CGPoint(x: 0.51, y: 0.38))
                path9.addCurve(to: CGPoint(x: 1.57, y: 4.33), controlPoint1: CGPoint(x: -0.28, y: 2.75), controlPoint2: CGPoint(x: 0.38, y: 3.94))
                path9.addCurve(to: CGPoint(x: 3.54, y: 6.71), controlPoint1: CGPoint(x: 2.88, y: 4.73), controlPoint2: CGPoint(x: 3.41, y: 6.05))
                path9.addCurve(to: CGPoint(x: 2.49, y: 10.8), controlPoint1: CGPoint(x: 3.94, y: 8.16), controlPoint2: CGPoint(x: 3.41, y: 9.74))
                path9.addCurve(to: CGPoint(x: 2.49, y: 13.96), controlPoint1: CGPoint(x: 1.57, y: 11.59), controlPoint2: CGPoint(x: 1.57, y: 13.04))
                path9.addCurve(to: CGPoint(x: 4.07, y: 14.62), controlPoint1: CGPoint(x: 2.88, y: 14.36), controlPoint2: CGPoint(x: 3.54, y: 14.62))
                path9.addCurve(to: CGPoint(x: 5.65, y: 13.96), controlPoint1: CGPoint(x: 4.6, y: 14.62), controlPoint2: CGPoint(x: 5.13, y: 14.36))
                path9.addCurve(to: CGPoint(x: 7.9, y: 5.79), controlPoint1: CGPoint(x: 7.76, y: 11.98), controlPoint2: CGPoint(x: 8.55, y: 8.69))
                path9.addCurve(to: CGPoint(x: 2.88, y: 0.12), controlPoint1: CGPoint(x: 7.1, y: 2.88), controlPoint2: CGPoint(x: 5.39, y: 0.91))
                path9.addLine(to: CGPoint(x: 2.88, y: 0.12))
                path9.close()
                context.saveGState()
                context.translateBy(x: 68.51, y: 8.72)
                if isSelected {
                    UIColor.lhTurquoise.setFill()
                } else {
                    UIColor.white.setFill()
                }
                path9.fill()
                context.restoreGState()
                
                context.restoreGState()
            }
            
            context.restoreGState()
        }
        
        context.restoreGState()
    }
}
