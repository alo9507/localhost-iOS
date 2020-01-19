//
//  man.swift
//  Contact
//
//  Created by Andrew O'Brien on 1/11/20.
//  Copyright © 2020 Andrew O'Brien. All rights reserved.
//

import Foundation
import UIKit

class man: NiblessView {
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
        let context = UIGraphicsGetCurrentContext()!
        
        /// Resize to Target Frame
        context.saveGState()
        let resizedFrame = resizing.apply(rect: CGRect(x: 0, y: 0, width: 160, height: 280), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 160, y: resizedFrame.height / 280)
        
        /// man
        do {
            context.saveGState()
            context.translateBy(x: 31, y: 0)
            
            /// Path
            let path = UIBezierPath()
            path.move(to: CGPoint(x: 28, y: 56))
            path.addCurve(to: CGPoint(x: 56, y: 28), controlPoint1: CGPoint(x: 43.47, y: 56), controlPoint2: CGPoint(x: 56, y: 43.47))
            path.addCurve(to: CGPoint(x: 28, y: 0), controlPoint1: CGPoint(x: 56, y: 12.53), controlPoint2: CGPoint(x: 43.47, y: 0))
            path.addCurve(to: CGPoint(x: 0, y: 28), controlPoint1: CGPoint(x: 12.53, y: 0), controlPoint2: CGPoint(x: 0, y: 12.53))
            path.addCurve(to: CGPoint(x: 28, y: 56), controlPoint1: CGPoint(x: 0, y: 43.47), controlPoint2: CGPoint(x: 12.53, y: 56))
            path.close()
            context.saveGState()
            context.translateBy(x: 21, y: 0)
            if isSelected {
                UIColor.lhTurquoise.setFill()
            } else {
                UIColor.white.setFill()
            }
            path.fill()
            context.restoreGState()
            
            /// Path
            let path2 = UIBezierPath()
            path2.move(to: CGPoint(x: 70, y: 0))
            path2.addLine(to: CGPoint(x: 28, y: 0))
            path2.addCurve(to: CGPoint(x: 0, y: 27.87), controlPoint1: CGPoint(x: 12.6, y: 0), controlPoint2: CGPoint(x: 0, y: 12.54))
            path2.addLine(to: CGPoint(x: 0, y: 104.5))
            path2.addLine(to: CGPoint(x: 21, y: 104.5))
            path2.addLine(to: CGPoint(x: 21, y: 209))
            path2.addLine(to: CGPoint(x: 77, y: 209))
            path2.addLine(to: CGPoint(x: 77, y: 104.5))
            path2.addLine(to: CGPoint(x: 98, y: 104.5))
            path2.addLine(to: CGPoint(x: 98, y: 27.87))
            path2.addCurve(to: CGPoint(x: 70, y: 0), controlPoint1: CGPoint(x: 98, y: 12.54), controlPoint2: CGPoint(x: 85.4, y: 0))
            path2.close()
            context.saveGState()
            context.translateBy(x: 0, y: 70)
            if isSelected {
                UIColor.lhTurquoise.setFill()
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
