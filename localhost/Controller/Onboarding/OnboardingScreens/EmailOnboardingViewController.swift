//
//  EmailOnboardingViewController.swift
//  Contact
//
//  Created by Andrew O'Brien on 12/13/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import UIKit
import SnapKit

class EmailOnboardingViewController: OnboardingViewController {
    let emailTextField = OnboardingTextField(placeholder: "morty@therick.com", keyboardType: .emailAddress)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupEmailTextField()
    }
    
    override func didFinishAppearanceTransition() {
        emailTextField.becomeFirstResponder()
    }
    
    override func didTapInputContainer() {
        emailTextField.becomeFirstResponder()
    }
}

extension EmailOnboardingViewController {
    private func setupEmailTextField() {
        inputContainer.addSubview(emailTextField)
        
        emailTextField.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.width.equalToSuperview().inset(15)
            make.centerX.equalToSuperview()
        }
        emailTextField.keyboardType = .URL
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
}

extension EmailOnboardingViewController {
    @objc
    func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else {
            return
        }
        
        nextButton.isActive = isValid(text)
    }
}

extension EmailOnboardingViewController {
    func isValid(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z]+([._%+-]{1}[A-Z0-9a-z]+)*@[A-Z0-9a-z]+([.-]{1}[A-Z0-9a-z]+)*(\\.[A-Za-z]{2,4}){0,1}"
        
        let emailTest = NSPredicate(format: "SELF MATCHES[c] %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
}
