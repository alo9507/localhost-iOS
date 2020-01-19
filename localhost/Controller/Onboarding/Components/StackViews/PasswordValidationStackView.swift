//
//  PasswordValidationStackView.swift
//  Contact
//
//  Created by Andrew O'Brien on 12/13/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation
import UIKit

class PasswordValidationStackView: UIStackView {
    let letterValidationLabel = PasswordVerificationLabel(title: "Must contain characters")
    let symbolNumberValidationLabel = PasswordVerificationLabel(title: "Must contain a number or symbol")
    let characterLimitValidationLabel = PasswordVerificationLabel(title: "Must be at least 8 characters")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setProperties()
        setSubviews()
    }
    
    func setProperties() {
        translatesAutoresizingMaskIntoConstraints = false
        axis = .vertical
        distribution = .equalSpacing
        alignment = .leading
        spacing = 15
    }
    
    func setSubviews() {
        insertArrangedSubview(letterValidationLabel, at: 0)
        insertArrangedSubview(symbolNumberValidationLabel, at: 1)
        insertArrangedSubview(characterLimitValidationLabel, at: 2)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
