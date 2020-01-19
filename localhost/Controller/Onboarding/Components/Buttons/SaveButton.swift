//
//  SaveButton.swift
//  Contact
//
//  Created by Andrew O'Brien on 12/23/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation
import UIKit

class SaveButton: UIButton {
    private var title: String
    
    override init(frame: CGRect) {
        self.title = "Set a title"
        super.init(frame: frame)
    }
    
    convenience init(_ text: String) {
        self.init(frame: .zero)
        self.title = text
        setProperties()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setProperties() {
        let attributedTitle = NSAttributedString(string: title, attributes: [
            NSAttributedString.Key.foregroundColor : UIColor.white,
            NSAttributedString.Key.font: Fonts.avenirNext_demibold(24)
        ])
        
        layer.cornerRadius = 25
        sizeToFit()
        setAttributedTitle(attributedTitle, for: .normal)
        backgroundColor = UIColor.lhPink
        layer.cornerRadius = 20
    }
}
