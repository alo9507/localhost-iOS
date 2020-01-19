//
//  OnboardingTitleLabel.swift
//  Contact
//
//  Created by Andrew O'Brien on 12/13/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation
import UIKit

class OnboardingTitleLabel: OnboardingLabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(_ text: String) {
        self.init(frame: .zero)
        self.text = text
        setTextProperties(text: text)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setTextProperties(text: String) {
        textColor = UIColor.init(hexString: "#2DD3CB", withAlpha: 1.0)
        
        let textString = NSMutableAttributedString(string: text, attributes: [.font: Fonts.avenirNext_bold(24)])
        numberOfLines = 0
        sizeToFit()
        textAlignment = .center
        attributedText = textString
    }
}
