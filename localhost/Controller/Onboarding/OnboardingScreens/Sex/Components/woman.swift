//
//  woman.swift
//  Contact
//
//  Created by Andrew O'Brien on 1/11/20.
//  Copyright © 2020 Andrew O'Brien. All rights reserved.
//

import Foundation
import UIKit

class woman: NiblessView {
    var isSelected: Bool = false {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
    }
    
    let targetFrame: CGRect = CGRect(x: 0, y: 0, width: 160, height: 280)
    let resizing: LocalhostStyleKit.ResizingBehavior = .aspectFit
    override func draw(_ rect: CGRect) {
        /// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        /// Resize to Target Frame
        context.saveGState()
        let resizedFrame = resizing.apply(rect: CGRect(x: 0, y: 0, width: 160, height: 280), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 160, y: resizedFrame.height / 280)
        
        /// woman
        do {
            context.saveGState()
            context.translateBy(x: 18, y: 0)
            
            /// Path
            let path = UIBezierPath()
            path.move(to: CGPoint(x: 27.5, y: 56))
            path.addCurve(to: CGPoint(x: 55, y: 28), controlPoint1: CGPoint(x: 42.69, y: 56), controlPoint2: CGPoint(x: 55, y: 43.47))
            path.addCurve(to: CGPoint(x: 27.5, y: 0), controlPoint1: CGPoint(x: 55, y: 12.53), controlPoint2: CGPoint(x: 42.69, y: 0))
            path.addCurve(to: CGPoint(x: 0, y: 28), controlPoint1: CGPoint(x: 12.31, y: 0), controlPoint2: CGPoint(x: 0, y: 12.53))
            path.addCurve(to: CGPoint(x: 27.5, y: 56), controlPoint1: CGPoint(x: 0, y: 43.47), controlPoint2: CGPoint(x: 12.31, y: 56))
            path.close()
            context.saveGState()
            context.translateBy(x: 35, y: 0)
            if isSelected {
                UIColor.lhPink.setFill()
            } else {
                UIColor.white.setFill()
            }
            path.fill()
            context.restoreGState()
            
            /// Path
            let path2 = UIBezierPath()
            path2.move(to: CGPoint(x: 89.65, y: 19.18))
            path2.addCurve(to: CGPoint(x: 63.33, y: 0), controlPoint1: CGPoint(x: 85.9, y: 7.7), controlPoint2: CGPoint(x: 75.28, y: 0))
            path2.addLine(to: CGPoint(x: 61.74, y: 0))
            path2.addCurve(to: CGPoint(x: 35.42, y: 19.18), controlPoint1: CGPoint(x: 49.79, y: 0), controlPoint2: CGPoint(x: 39.17, y: 7.7))
            path2.addLine(to: CGPoint(x: 0, y: 126))
            path2.addLine(to: CGPoint(x: 41.67, y: 126))
            path2.addLine(to: CGPoint(x: 41.67, y: 210))
            path2.addLine(to: CGPoint(x: 83.33, y: 210))
            path2.addLine(to: CGPoint(x: 83.33, y: 126))
            path2.addLine(to: CGPoint(x: 125, y: 126))
            path2.addLine(to: CGPoint(x: 89.65, y: 19.18))
            path2.close()
            context.saveGState()
            context.translateBy(x: 0, y: 70)
            if isSelected {
                UIColor.lhPink.setFill()
            } else {
                UIColor.white.setFill()
            }
            path2.fill()
            context.restoreGState()
            
            context.restoreGState()
        }
        
        context.restoreGState()
    }
}
