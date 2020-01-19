//
//  MobileOnboardingViewController.swift
//  Contact
//
//  Created by Andrew O'Brien on 12/13/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import UIKit
import Foundation
import SnapKit
import FirebaseAuth
import SVProgressHUD

class MobileOnboardingViewController: OnboardingViewController {
    
    let countryLabel = UILabel()
    let container = UIView()
    var credential: PhoneAuthCredential?
    
    let phoneNumberTextField = OnboardingTextField(placeholder: "(123) 456-7890", keyboardType: .numberPad)
    let sendVerificationCodeButton: UIButton = {
        let sendVerificationCodeButton = UIButton(frame: CGRect(x: 100, y: 100, width: 400, height: 75))
        
        let attributedTitle = NSAttributedString(string: "send verification sms", attributes: [
            NSAttributedString.Key.foregroundColor : UIColor.lhPink,
            NSAttributedString.Key.font: Fonts.avenirNext_bold(20)
        ])
        
        sendVerificationCodeButton.setAttributedTitle(attributedTitle, for: .normal)
        
        sendVerificationCodeButton.layer.cornerRadius = 20
        sendVerificationCodeButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        sendVerificationCodeButton.backgroundColor = UIColor.lhTurquoise
        
        sendVerificationCodeButton.addTarget(self, action: #selector(verifyPhoneNumber), for: .touchUpInside)
        return sendVerificationCodeButton
    }()
    
    let smsCodeTextField = OnboardingTextField(placeholder: "00000", keyboardType: .numberPad)
    let submitCodeButton: UIButton = {
        let sendVerificationCodeButton = UIButton(frame: CGRect(x: 100, y: 100, width: 400, height: 75))
        
        let attributedTitle = NSAttributedString(string: "submit code", attributes: [
            NSAttributedString.Key.foregroundColor : UIColor.lhPink,
            NSAttributedString.Key.font: Fonts.avenirNext_bold(20)
        ])
        
        sendVerificationCodeButton.setAttributedTitle(attributedTitle, for: .normal)
        
        sendVerificationCodeButton.layer.cornerRadius = 20
        sendVerificationCodeButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        sendVerificationCodeButton.backgroundColor = UIColor.lhTurquoise
        
        sendVerificationCodeButton.addTarget(self, action: #selector(didEnterSmsCode), for: .touchUpInside)
        return sendVerificationCodeButton
    }()
    
    let descriptionLabel = OnboardingSubtitleLabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        setCountryLabel()
//        setContainer()
        setMobileTextField()
        setSendVerificationCodeButton()
        setSmsCodeTextField()
        setSubmitCodeButton()
        setDescriptionLabel()
    }
    
    override func didFinishAppearanceTransition() {
        phoneNumberTextField.becomeFirstResponder()
    }
    
    override func didTapInputContainer() {
        phoneNumberTextField.becomeFirstResponder()
    }
    
}

extension MobileOnboardingViewController {
    func setCountryLabel() {
        inputContainer.addSubview(countryLabel)
        
        countryLabel.snp.makeConstraints { (make) in
            make.right.equalTo(phoneNumberTextField).offset(-5)
            make.centerY.equalTo(phoneNumberTextField)
        }
        
        countryLabel.text = "🇺🇸"
        countryLabel.font = Fonts.avenirNext_regular(16)
        countryLabel.textAlignment = .center
        countryLabel.sizeToFit()
    }
    
    func setContainer() {
        inputContainer.addSubview(container)
        
        container.snp.makeConstraints { (make) in
            make.left.equalTo(countryLabel.snp.right).inset(-17)
            make.right.height.equalToSuperview()
        }
        
        let border = UIView()
        border.frame = CGRect(x: 0, y: 0, width: 0.5, height: inputContainer.frame.size.height)
        border.layer.borderWidth = 0.5
        border.layer.borderColor = UIColor(red: 0.59, green: 0.59, blue: 0.59, alpha: 0.5).cgColor
        border.autoresizingMask = [.flexibleHeight, .flexibleRightMargin]
        container.addSubview(border)
    }
    
    func setMobileTextField() {
        inputContainer.addSubview(phoneNumberTextField)
        
        phoneNumberTextField.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(45)
        }
        
        phoneNumberTextField.delegate = self
    }
    
    func setSendVerificationCodeButton() {
        inputContainer.addSubview(sendVerificationCodeButton)
        
        sendVerificationCodeButton.snp.makeConstraints { (make) in
            make.top.equalTo(phoneNumberTextField.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(45)
        }
    }
    
    func setSmsCodeTextField() {
        inputContainer.addSubview(smsCodeTextField)
        
        smsCodeTextField.snp.makeConstraints { (make) in
            make.top.equalTo(sendVerificationCodeButton.snp.bottom).offset(25)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(45)
        }
        
        smsCodeTextField.alpha = 0
    }
    
    func setSubmitCodeButton() {
        inputContainer.addSubview(submitCodeButton)
        
        submitCodeButton.snp.makeConstraints { (make) in
            make.top.equalTo(smsCodeTextField.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(45)
        }
        
        submitCodeButton.alpha = 0
        inputContainer.resizeToFitSubviews()
    }
    
    func setDescriptionLabel() {
        view.addSubview(descriptionLabel)
        
        descriptionLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(30)
            make.right.equalTo(nextButton.snp.left).inset(-21)
            make.centerY.equalTo(nextButton)
        }
        
        descriptionLabel.text = "Text should arrive in 30 minutes"
        descriptionLabel.font = Fonts.avenirNext_bold(12)
    }
}

extension MobileOnboardingViewController {
    private func formattedNumber(number: String) -> String {
        let cleanPhoneNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let mask = "(XXX) XXX-XXXX"
        
        var result = ""
        var index = cleanPhoneNumber.startIndex
        for ch in mask where index < cleanPhoneNumber.endIndex {
            if ch == "X" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        
        nextButton.isActive = result.count == mask.count
        
        return result
    }
    
    private func rawNumber(formattedNumber: String) -> String {
        let formattedNumber = phoneNumberTextField.text!
        let digits = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        
        var rawPhoneNumber = ""
        for char in formattedNumber {
            if digits.contains(String(char)) {
                rawPhoneNumber += String(char)
            }
        }
        return rawPhoneNumber
    }
}

extension MobileOnboardingViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        textField.text = formattedNumber(number: newString)
        return false
    }
}

extension MobileOnboardingViewController {
    @objc
    func verifyPhoneNumber() {
        UIView.animate(withDuration: 0.2) {
            self.smsCodeTextField.alpha = 1
            self.submitCodeButton.alpha = 1
        }
        smsCodeTextField.becomeFirstResponder()
        
        let rawPhoneNumber = "+1\(rawNumber(formattedNumber: phoneNumberTextField.text!))"
        PhoneAuthProvider.provider().verifyPhoneNumber(rawPhoneNumber, uiDelegate: nil) { (verificationID, error) in
          if let error = error {
            print("ERROR VERIFYING PHONE NUMBER!: \(error)")
            return
          }
          UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
        }
    }
    
    @objc
    func didEnterSmsCode() {
        SVProgressHUD.show()
        let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
        
        credential = PhoneAuthProvider.provider().credential(
                                                withVerificationID: verificationID!,
                                                verificationCode: smsCodeTextField.text!)
        
        Auth.auth().signInAndRetrieveData(with: credential!) { (authResult, error) in
            SVProgressHUD.dismiss()
            if let error = error {
                let nsError = error as NSError
                switch nsError.userInfo["error_name"] as? String {
                case "ERROR_INVALID_VERIFICATION_CODE":
                    let alert = UIAlertController(title: "Wrong Verification Code", message: "The verification code you entered does not mathc the one you were sent.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                default:
                    let alert = UIAlertController(title: "Something Went Wrong", message: "Unknown Error", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                
                return print("Failed to sign in user with phone number: \(error)")
            }
            print(authResult?.user.phoneNumber)
            self.nextButtonPressed(UIButton())
        }
    }
}
