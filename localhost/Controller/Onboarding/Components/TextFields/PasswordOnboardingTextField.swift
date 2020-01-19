//
//  PasswordOnboardingTextField.swift
//  Contact
//
//  Created by Andrew O'Brien on 12/13/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import UIKit
import SnapKit

class PasswordOnboardingTextField: OnboardingTextField {
    
    let hideLabel = OnboardingTappableLabel()
    
    private var padding: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 7, bottom: 0, right: hideLabel.frame.width + 7)
    }
    
    override var isSecureTextEntry: Bool {
        didSet {
            hideLabel.text = isSecureTextEntry ? "SHOW" : "HIDE"
        }
    }
    
    init(placeholder: String? = nil, keyboardType: UIKeyboardType = .default) {
        super.init(placeholder: placeholder, keyboardType: keyboardType)
        
        isSecureTextEntry = true
        setHideLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    private func setHideLabel() {
        addSubview(hideLabel)
        
        hideLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(5)
            make.centerY.equalToSuperview()
        }
        
        hideLabel.font = Fonts.avenirNext_demibold(13)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideLabelPressed(_:)))
        hideLabel.addGestureRecognizer(tapGesture)
        hideLabel.text = "SHOW"
        hideLabel.textColor = .white
        hideLabel.isUserInteractionEnabled = true
    }
    
    @objc
    func hideLabelPressed(_ gesture: UITapGestureRecognizer) {
        isSecureTextEntry = !isSecureTextEntry
    }
}
