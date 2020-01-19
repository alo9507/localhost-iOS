//
//  OnboardingErrorLabel.swift
//  Contact
//
//  Created by Andrew O'Brien on 12/13/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation
import UIKit

class OnboardingErrorLabel: OnboardingLabel {
    override func setTextProperties(text: String) {
        textColor = UIColor(red: 1, green: 0.23, blue: 0.19, alpha: 1)
        
        let textString = NSMutableAttributedString(string: text, attributes: [.font: Fonts.avenirNext_regular(11)])
        let textRange = NSRange(location: 0, length: textString.length)
        let paragraphyStyle = NSMutableParagraphStyle()
        paragraphyStyle.lineSpacing = 1.45
        
        textString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphyStyle, range: textRange)
        
        attributedText = textString
    }
}
