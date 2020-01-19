//
//  OnboardingLabel.swift
//  Contact
//
//  Created by Andrew O'Brien on 12/13/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation
import UIKit

class OnboardingLabel: UILabel {
    override var text: String? {
        didSet {
            guard let text = text else {
                return
            }
            setTextProperties(text: text)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setProperties()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setProperties() {
        textColor = UIColor.init(hexString: "#2DD3CB", withAlpha: 1.0)
        textAlignment = .center
        numberOfLines = 0
        lineBreakMode = .byWordWrapping
        sizeToFit()
        setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        font = Fonts.avenirNext_regular(16)
    }
    
    func setTextProperties(text: String) {}
}
