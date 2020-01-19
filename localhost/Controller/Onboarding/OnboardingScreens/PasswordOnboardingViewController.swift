//
//  PasswordOnboardingViewController.swift
//  Contact
//
//  Created by Andrew O'Brien on 12/13/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class PasswordOnboardingViewController: OnboardingViewController {
    let passwordTextField = PasswordOnboardingTextField(placeholder: "supersecret123!", keyboardType: .default)
    
    let passwordVerificationStackView = PasswordValidationStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setPasswordTextField()
        setStackView()
    }
    
    override func didFinishAppearanceTransition() {
        passwordTextField.becomeFirstResponder()
        
        UIView.animate(withDuration: 0.2) {
            self.passwordVerificationStackView.alpha = 1
        }
    }
}

extension PasswordOnboardingViewController {
    func setPasswordTextField() {
        inputContainer.addSubview(passwordTextField)
        
        passwordTextField.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.width.equalToSuperview().inset(15)
            make.centerX.equalToSuperview()
        }
        
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    func setStackView() {
        view.addSubview(passwordVerificationStackView)
        
        passwordVerificationStackView.alpha = 0
        
        passwordVerificationStackView.snp.makeConstraints { (make) in
            make.top.equalTo(inputContainer.snp.bottom).offset(40)
            make.left.equalToSuperview().inset(34)
            make.right.equalToSuperview().inset(15)
        }
    }
}

extension PasswordOnboardingViewController {
    @objc
    func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else {
            return
        }
        
        passwordVerificationStackView.characterLimitValidationLabel.isValid = isValidLength(text)
        passwordVerificationStackView.letterValidationLabel.isValid = containsLetter(text)
        passwordVerificationStackView.symbolNumberValidationLabel.isValid = containsSymbolOrNumber(text)
        
        nextButton.isActive = isValidLength(text) && containsLetter(text) && containsSymbolOrNumber(text)
    }
}

extension PasswordOnboardingViewController {
    func isValidLength(_ textString: String) -> Bool {
        return textString.count >= 8
    }
    
    func containsLetter(_ textString: String) -> Bool {
        return textString.rangeOfCharacter(from: CharacterSet.letters) != nil
    }
    
    func containsSymbolOrNumber(_ textString: String) -> Bool {
        return textString.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) != nil || textString.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil
    }
}
