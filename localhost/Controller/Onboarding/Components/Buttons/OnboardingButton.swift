//
//  OnboardingButton.swift
//  Contact
//
//  Created by Andrew O'Brien on 12/13/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation
import UIKit

class OnboardingButton: UIButton {
    
    var minimumHitArea = CGSize(width: 100, height: 100)
    
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // if hidden can't hit
        if self.isHidden || !self.isUserInteractionEnabled || self.alpha < 0.01 { return nil }
        
        // increase hit frame to be atleast minHitArea
        let buttonSize = self.bounds.size
        let widthToAdd = max(minimumHitArea.width - buttonSize.width, 0)
        let heightToAdd = max(minimumHitArea.height - buttonSize.height, 0)
        let largerFrame = self.bounds.insetBy(dx: -widthToAdd / 2, dy: -heightToAdd / 2)
        
        return (largerFrame.contains(point)) ? self : nil
    }
}
