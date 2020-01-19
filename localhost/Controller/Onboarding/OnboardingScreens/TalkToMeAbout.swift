//
//  TalkToMeAbout.swift
//  Contact
//
//  Created by Andrew O'Brien on 12/25/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import UIKit
import SnapKit

class TalkToMeAbout: OnboardingViewController {
    
    let topicsStackView: UIStackView = {
        let topicsStackView = UIStackView()
        topicsStackView.translatesAutoresizingMaskIntoConstraints = false
        topicsStackView.axis = .vertical
        topicsStackView.distribution = .equalSpacing
        topicsStackView.alignment = .leading
        topicsStackView.spacing = 15
        return topicsStackView
    }()
    
    let firstTopic = OnboardingTextField(placeholder: "cocktail mixing", keyboardType: .default, returnKeyType: .next)
    let secondTopic = OnboardingTextField(placeholder: "software development", keyboardType: .default, returnKeyType: .next)
    let thirdTopic = OnboardingTextField(placeholder: "butter making", keyboardType: .default, returnKeyType: .done)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.isActive = true
        firstTopic.delegate = self
        secondTopic.delegate = self
        thirdTopic.delegate = self
        render()
    }
    
    override func didFinishAppearanceTransition() {
        firstTopic.becomeFirstResponder()
    }
}

extension TalkToMeAbout {
    func render() {
        inputContainer.addSubview(topicsStackView)
        
        topicsStackView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(15)
        }
        
        topicsStackView.insertArrangedSubview(firstTopic, at: 0)
        topicsStackView.insertArrangedSubview(secondTopic, at: 1)
        topicsStackView.insertArrangedSubview(thirdTopic, at: 2)
        topicsStackView.layoutIfNeeded()
        
        inputContainer.resizeToFitSubviews()
    }
}

extension TalkToMeAbout: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === firstTopic {
            secondTopic.becomeFirstResponder()
        }
        if textField === secondTopic {
            thirdTopic.becomeFirstResponder()
        }
        if textField === thirdTopic {
            self.nextButtonPressed(UIButton())
        }
        return false
    }
}
