//
//  SingleSelectionBubble.swift
//  Contact
//
//  Created by Andrew O'Brien on 12/26/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation
import UIKit

class SelectionBubble: UILabel {
    var selected: Bool = false {
        didSet {
            setProperties()
        }
    }
    
    init(_ text: String) {
        super.init(frame: .zero)
        self.text = text
        setProperties()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setProperties() {
        isUserInteractionEnabled = true
        textAlignment = .center
        layer.cornerRadius = 20
        font = Fonts.avenirNext_bold(25)
        
        if selected {
            textColor = UIColor.lhYellow
            backgroundColor = UIColor.lhPurple
            layer.borderColor = UIColor.lhPink.cgColor
            layer.borderWidth = 2
        } else {
            textColor = UIColor.lhPink
            backgroundColor = UIColor.lhPurple
            layer.borderColor = UIColor.lhYellow.cgColor
            layer.borderWidth = 2
        }
    }
}
