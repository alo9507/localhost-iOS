//
//  OnboardingSubtitleLabel.swift
//  Contact
//
//  Created by Andrew O'Brien on 12/13/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import UIKit

class OnboardingSubtitleLabel: OnboardingLabel {
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
        textColor = UIColor.lhYellow
        
        let textString = NSMutableAttributedString(string: text, attributes: [.font: Fonts.avenirNext_demibold(18)])
        numberOfLines = 0
        sizeToFit()
        textAlignment = .center
        attributedText = textString
    }
}
