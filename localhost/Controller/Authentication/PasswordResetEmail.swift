//
//  PasswordResetEmail.swift
//  Contact
//
//  Created by Andrew O'Brien on 12/26/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import SnapKit

class PasswordResetEmail: NiblessViewController {
    var localhostLabel: UILabel = {
        let localhostLabel = UILabel()
        localhostLabel.text = "localhost"
        localhostLabel.textAlignment = .center
        localhostLabel.font = Fonts.avenirNext_bold(70)
        localhostLabel.textColor = UIColor.lhYellow
        return localhostLabel
    }()
    
    lazy var forgotPasswordLabel: OnboardingLabel = {
        let forgotPasswordLabel = OnboardingLabel()
        forgotPasswordLabel.text = "forgot your password? no problem!"
        return forgotPasswordLabel
    }()
    
    lazy var explanationLabel: OnboardingLabel = {
        let explanationLabel = OnboardingLabel()
        explanationLabel.text = "Enter your email address and we will send you instructions on how to create a new password"
        return explanationLabel
    }()
    
    lazy var emailResetTextField: OnboardingTextField = OnboardingTextField(placeholder: "email", keyboardType: .default)
    
    lazy var sendResetEmailLabel: UIButton = {
        let authenticationButton = UIButton()
        
        let attributedTitle = NSAttributedString(string: "submit", attributes: [
            NSAttributedString.Key.foregroundColor : UIColor.lhYellow,
            NSAttributedString.Key.font: Fonts.avenirNext_bold(28)
        ])
        
        authenticationButton.setAttributedTitle(attributedTitle, for: .normal)
        authenticationButton.layer.cornerRadius = 20
        authenticationButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        authenticationButton.backgroundColor = UIColor.lhTurquoise
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(sendResetPressed))
        tapGesture.numberOfTapsRequired = 1
        authenticationButton.addGestureRecognizer(tapGesture)
        
        return authenticationButton
    }()
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.lhPurple
        render()
    }
}

extension PasswordResetEmail {
    @objc
    func sendResetPressed() {
        Auth.auth().sendPasswordReset(withEmail: emailResetTextField.text!) { error in
            let alert = UIAlertController(title: "Email Sent", message: "A password reset email has been sent to \(self.emailResetTextField.text!)", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
                self.dismiss(animated: true, completion: nil)
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func render() {
        constructHierarchy()
        activateConstraints()
    }
    
    func constructHierarchy() {
        view.addSubview(localhostLabel)
        view.addSubview(emailResetTextField)
        view.addSubview(forgotPasswordLabel)
        view.addSubview(sendResetEmailLabel)
        view.addSubview(explanationLabel)
    }
    
    func activateConstraints() {
        localhostLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(150)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(15)
        }
        
        forgotPasswordLabel.snp.makeConstraints { (make) in
            make.top.equalTo(localhostLabel.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(15)
        }
        
        emailResetTextField.snp.makeConstraints { (make) in
            make.top.equalTo(forgotPasswordLabel.snp.bottom).offset(75)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(15)
        }
        
        sendResetEmailLabel.snp.makeConstraints { (make) in
            make.top.equalTo(emailResetTextField.snp.bottom).offset(15)
            make.width.equalToSuperview().inset(15)
            make.centerX.equalToSuperview()
        }
        
        explanationLabel.snp.makeConstraints { (make) in
            make.top.equalTo(sendResetEmailLabel.snp.bottom).offset(40)
            make.width.equalToSuperview().inset(15)
            make.centerX.equalToSuperview()
        }
    }
}
