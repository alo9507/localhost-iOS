//
//  SignUpWith.swift
//  Contact
//
//  Created by Andrew O'Brien on 12/24/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation
import UIKit

class SignUpWith: OnboardingViewController {
    
    var signUpChoice: String = "no_choice"
    
    var didChooseSignUpOption: ((String) -> Void)?
    
    lazy var useEmailButton: UIButton = {
        let useEmailButton = UIButton()
        let attributedTitle = NSAttributedString(string: "Email", attributes: [
            NSAttributedString.Key.foregroundColor : UIColor.lhPink,
            NSAttributedString.Key.font: Fonts.avenirNext_demibold(24)
        ])
        
        useEmailButton.layer.borderColor = UIColor.lhPink.cgColor
        useEmailButton.layer.borderWidth = 4
        useEmailButton.layer.cornerRadius = 20
        useEmailButton.sizeToFit()
        
        useEmailButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        useEmailButton.setAttributedTitle(attributedTitle, for: .normal)
        useEmailButton.addTarget(self, action: #selector(useEmail), for: .touchUpInside)
        return useEmailButton
    }()
    
    lazy var useMobileNumber: UIButton = {
        let useMobileNumber = UIButton()
        let attributedTitle = NSAttributedString(string: "Phone Number", attributes: [
            NSAttributedString.Key.foregroundColor : UIColor.lhPink,
            NSAttributedString.Key.font: Fonts.avenirNext_demibold(24)
        ])
        
        useMobileNumber.layer.borderColor = UIColor.lhPink.cgColor
        useMobileNumber.layer.borderWidth = 4
        useMobileNumber.layer.cornerRadius = 20
        useMobileNumber.sizeToFit()
        
        useMobileNumber.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        useMobileNumber.setAttributedTitle(attributedTitle, for: .normal)
        useMobileNumber.addTarget(self, action: #selector(useMobile), for: .touchUpInside)
        return useMobileNumber
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        render()
    }
}

extension SignUpWith {
    func render() {
        constructHierarchy()
        activateConstrains()
    }
    
    func constructHierarchy() {
        inputContainer.addSubview(useEmailButton)
        inputContainer.addSubview(useMobileNumber)
        inputContainer.resizeToFitSubviews()
    }
    
    func activateConstrains() {
        useEmailButton.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        useMobileNumber.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.top.equalTo(useEmailButton.snp.bottom).offset(15)
        }
    }
}

extension SignUpWith {
    @objc
    private func useEmail(_ sender: UIButton) {
        signUpChoice = "email"
        didChooseSignUpOption?(signUpChoice)
        nextButtonPressed(sender)
    }
    
    @objc
    private func useMobile(_ sender: UIButton) {
        signUpChoice = "mobile"
        didChooseSignUpOption?(signUpChoice)
        nextButtonPressed(sender)
    }
}
