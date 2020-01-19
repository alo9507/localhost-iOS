//
//  DateLabel.swift
//  Contact
//
//  Created by Andrew O'Brien on 12/23/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation
import UIKit

class DateLabel: UILabel {
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
    }
    
    convenience init(_ text: String) {
        self.init(frame: .zero)
        self.text = text
        setProperties()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setProperties() {
        textColor = UIColor.init(hexString: "#2DD3CB", withAlpha: 1.0)
        font = Fonts.avenirNext_bold(18)
        textColor = UIColor.lhPink
        textAlignment = .left
        numberOfLines = 0
        lineBreakMode = .byWordWrapping
        sizeToFit()
        setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
    
    func setTextProperties(text: String) {}
}
