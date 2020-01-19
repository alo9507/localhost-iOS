//
//  MaritalStatus.swift
//  Contact
//
//  Created by Andrew O'Brien on 12/26/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class MaritalStatusOnboarding: OnboardingViewController {
    lazy var singleIcon: single = {
        let singleIcon = single()
        singleIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectStatus(_:))))
        return singleIcon
    }()
    lazy var singleLabel: UILabel = {
        let singleLabel = UILabel()
        singleLabel.text = "single"
        singleLabel.textColor = .white
        singleLabel.textAlignment = .center
        singleLabel.font = Fonts.avenirNext_bold(18)
        return singleLabel
    }()
    
    lazy var inRelationshipIcon: inRelationship = {
        let inRelationshipIcon = inRelationship()
        inRelationshipIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectStatus(_:))))
        return inRelationshipIcon
    }()
    lazy var inRelationshipLabel: UILabel = {
        let inRelationshipLabel = UILabel()
        inRelationshipLabel.text = "in a relationship"
        inRelationshipLabel.textColor = .white
        inRelationshipLabel.textAlignment = .center
        inRelationshipLabel.font = Fonts.avenirNext_bold(18)
        return inRelationshipLabel
    }()
    
    lazy var marriedIcon: married = {
        let marriedIcon = married()
        marriedIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectStatus(_:))))
        return marriedIcon
    }()
    lazy var marriedLabel: UILabel = {
        let marriedLabel = UILabel()
        marriedLabel.text = "married"
        marriedLabel.textColor = .white
        marriedLabel.textAlignment = .center
        marriedLabel.font = Fonts.avenirNext_bold(18)
        return marriedLabel
    }()
    
    lazy var skipLabel: UILabel = {
        let skipLabel = UILabel()
        skipLabel.text = "Skip >"
        skipLabel.font = Fonts.avenirNext_regular(40)
        skipLabel.textAlignment = .center
        skipLabel.textColor = .gray
        skipLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(skipPressed)))
        return skipLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.isActive = true
        setupView()
    }
    
    var selectedMaritalStatus: String = "unknown"
    
    func setupView() {
        inputContainer.addSubview(singleIcon)
        inputContainer.addSubview(singleLabel)
        
        inputContainer.addSubview(inRelationshipIcon)
        inputContainer.addSubview(inRelationshipLabel)
        
        inputContainer.addSubview(marriedIcon)
        inputContainer.addSubview(marriedLabel)
        
        inputContainer.addSubview(skipLabel)
        
        singleIcon.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(120)
            make.top.equalToSuperview()
        }
        singleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(singleIcon.snp.bottom).offset(3)
            make.width.equalToSuperview()
            make.height.equalTo(50)
        }
        
        inRelationshipIcon.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(120)
            make.top.equalTo(singleLabel.snp.bottom).offset(20)
        }
        inRelationshipLabel.snp.makeConstraints { (make) in
            make.top.equalTo(inRelationshipIcon.snp.bottom).offset(3)
            make.width.equalToSuperview()
            make.height.equalTo(50)
        }
        
        marriedIcon.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(120)
            make.top.equalTo(inRelationshipLabel.snp.bottom).offset(20)
        }
        marriedLabel.snp.makeConstraints { (make) in
            make.top.equalTo(marriedIcon.snp.bottom).offset(3)
            make.width.equalToSuperview()
            make.height.equalTo(50)
        }
        
        skipLabel.snp.makeConstraints { (make) in
            make.top.equalTo(marriedLabel.snp.bottom).offset(3)
            make.width.equalToSuperview()
            make.height.equalTo(50)
        }
        
        inputContainer.resizeToFitSubviews(600)
    }
    
    @objc
    func didSelectStatus(_ sender: UITapGestureRecognizer) {
        if let singleIcon = sender.view as? single {
            self.selectedMaritalStatus = "single"
            singleIcon.isSelected = true
            inRelationshipIcon.isSelected = false
            marriedIcon.isSelected = false
            
            singleLabel.textColor = UIColor.lhTurquoise
            inRelationshipLabel.textColor = UIColor.white
            marriedLabel.textColor = UIColor.white
        }
        
        if let marriedIcon = sender.view as? married {
            self.selectedMaritalStatus = "married"
            singleIcon.isSelected = false
            inRelationshipIcon.isSelected = false
            marriedIcon.isSelected = true
            
            singleLabel.textColor = UIColor.white
            inRelationshipLabel.textColor = UIColor.white
            marriedLabel.textColor = UIColor.lhTurquoise
        }
        
        if let inRelationshipIcon = sender.view as? inRelationship {
            self.selectedMaritalStatus = "inRelationship"
            singleIcon.isSelected = false
            inRelationshipIcon.isSelected = true
            marriedIcon.isSelected = false
            
            singleLabel.textColor = UIColor.white
            inRelationshipLabel.textColor = UIColor.lhTurquoise
            marriedLabel.textColor = UIColor.white
        }
    }
    
    @objc
    func skipPressed() {
        self.selectedMaritalStatus = "unknown"
        self.nextButtonPressed(UIButton())
    }
}


