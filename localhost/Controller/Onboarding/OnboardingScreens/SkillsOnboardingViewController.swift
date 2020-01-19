//
//  SkillsOnboardingViewController.swift
//  Contact
//
//  Created by Andrew O'Brien on 12/25/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class SkillsOnboardingViewController: OnboardingViewController {
    
    let skillsStackView: UIStackView = {
        let skillsStackView = UIStackView()
        skillsStackView.translatesAutoresizingMaskIntoConstraints = false
        skillsStackView.axis = .vertical
        skillsStackView.distribution = .equalSpacing
        skillsStackView.alignment = .leading
        skillsStackView.spacing = 15
        return skillsStackView
    }()
    
    let firstSkill = OnboardingTextField(placeholder: "cocktail mixing", keyboardType: .default, returnKeyType: .next)
    let secondSkill = OnboardingTextField(placeholder: "software development", keyboardType: .default, returnKeyType: .next)
    let thirdSkill = OnboardingTextField(placeholder: "butter making", keyboardType: .default, returnKeyType: .done)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.isActive = true
        firstSkill.delegate = self
        secondSkill.delegate = self
        thirdSkill.delegate = self
        render()
    }
    
    override func didFinishAppearanceTransition() {
        firstSkill.becomeFirstResponder()
    }
    
}

extension SkillsOnboardingViewController {
    func render() {
        inputContainer.addSubview(skillsStackView)
        
        skillsStackView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(15)
        }
        
        skillsStackView.insertArrangedSubview(firstSkill, at: 0)
        skillsStackView.insertArrangedSubview(secondSkill, at: 1)
        skillsStackView.insertArrangedSubview(thirdSkill, at: 2)
        skillsStackView.layoutIfNeeded()
        
        inputContainer.resizeToFitSubviews()
    }
}

extension SkillsOnboardingViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === firstSkill {
            secondSkill.becomeFirstResponder()
        }
        if textField === secondSkill {
            thirdSkill.becomeFirstResponder()
        }
        if textField === thirdSkill {
            self.nextButtonPressed(UIButton())
        }
        return false
    }
}
