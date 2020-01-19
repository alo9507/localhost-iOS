//
//  OnboardingTappableLabel.swift
//  Contact
//
//  Created by Andrew O'Brien on 12/13/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import UIKit

class OnboardingTappableLabel: OnboardingLabel {
    override func setTextProperties(text: String) {
        let textString = NSMutableAttributedString(string: text, attributes: [.font: font as Any])
        let textRange = NSRange(location: 0, length: textString.length)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.45
        
        textString.addAttribute(.paragraphStyle, value: paragraphStyle, range: textRange)
        
        attributedText = textString
    }
}
