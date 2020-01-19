//
//  NameOnboardingViewController.swift
//  Contact
//
//  Created by Andrew O'Brien on 12/12/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import UIKit

class NameOnboardingViewController: OnboardingViewController {
    let firstNameTextField = OnboardingTextField(placeholder: "first name", keyboardType: .default, returnKeyType: .next)
    
    let lastNameTextField: OnboardingTextField = OnboardingTextField(placeholder: "last name", keyboardType: .default, returnKeyType: .done)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        render()
    }
    
    override func didFinishAppearanceTransition() {
        firstNameTextField.becomeFirstResponder()
    }
}

extension NameOnboardingViewController {
    private func render() {
        inputContainer.addSubview(firstNameTextField)
        inputContainer.addSubview(lastNameTextField)
        
        inputContainer.frame.size.height = 300
        
        firstNameTextField.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.width.equalToSuperview().dividedBy(2).inset(15)
            make.centerX.equalToSuperview().multipliedBy(0.5)
        }
        
        lastNameTextField.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.width.equalToSuperview().dividedBy(2).inset(15)
            make.centerX.equalToSuperview().multipliedBy(1.5)
        }
        
        firstNameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        firstNameTextField.delegate = self
        firstNameTextField.autocorrectionType = .no
        
        lastNameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        lastNameTextField.delegate = self
        lastNameTextField.autocorrectionType = .no
    }
}

extension NameOnboardingViewController {
    @objc
    func textFieldDidChange(_ textField: UITextField) {
        guard let textField = textField as? OnboardingTextField else { return print("Not onboarding TF??") }
        
        guard let text = textField.text, !text.isEmpty else {
            nextButton.isActive = false
            textField.isValid = true
            return
        }
        
        guard let firstName = firstNameTextField.text, let lastName = lastNameTextField.text else {
            nextButton.isActive = false
            return
        }
        
        textField.isValid = isValid(text)
        
        nextButton.isActive = isValid(firstName) && isValid(lastName)
    }
}

extension NameOnboardingViewController {
    func isValid(_ name: String) -> Bool {
        let characterSet = CharacterSet.letters.union(CharacterSet(charactersIn: " ’'"))
        return characterSet.isSuperset(of: CharacterSet(charactersIn: name)) && name.count >= 1
    }
}

extension NameOnboardingViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === firstNameTextField {
            lastNameTextField.becomeFirstResponder()
        }
        
        if textField === lastNameTextField {
            self.nextButtonPressed(UIButton())
        }
        
        return false
    }
}
