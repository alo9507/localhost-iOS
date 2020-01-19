//
//  AffiliationView.swift
//  Contact
//
//  Created by Andrew O'Brien on 12/31/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation
import UIKit

class AffiliationView: NiblessView {
    let mainTitle: OnboardingTitleLabel = OnboardingTitleLabel("where do you work?")
    let subtitle: OnboardingSubtitleLabel = OnboardingSubtitleLabel("career, volunteering, the orgs that define you")
    let organizationName: OnboardingTextField = OnboardingTextField(placeholder: "Organization Name", keyboardType: .default, returnKeyType: .next)
    let role: OnboardingTextField = OnboardingTextField(placeholder: "Your Role", keyboardType: .default, returnKeyType: .next)
    
    let currentlyWorkHereLabel: DateLabel = DateLabel("I currently work here")
    lazy var currentlyWorkHereToggle: UISwitch = {
        let currentlyWorkHereToggle = UISwitch()
        currentlyWorkHereToggle.addTarget(viewController, action: #selector(AffiliationViewController.currentlyWorksHere), for: .valueChanged)
        return currentlyWorkHereToggle
    }()
    
    let fromLabel: DateLabel = DateLabel("From")
    lazy var fromButton: DateButton = {
        let fromField = DateButton("From")
        fromField.addTarget(viewController, action: #selector(AffiliationViewController.dateRangeTapped), for: .touchUpInside)
        return fromField
    }()
    
    let toLabel: DateLabel = DateLabel("To")
    lazy var toButton: DateButton = {
        let fromField = DateButton("To")
        fromField.addTarget(viewController, action: #selector(AffiliationViewController.dateRangeTapped), for: .touchUpInside)
        return fromField
    }()
    
    lazy var datePicker: UIPickerView = {
        let datePicker = UIPickerView()
        datePicker.delegate = viewController
        datePicker.dataSource = viewController
        return datePicker
    }()
    
    lazy var saveButton: SaveButton = {
        let saveButton = SaveButton("Save")
        saveButton.addTarget(viewController, action: #selector(AffiliationViewController.addOrEditAffiliation), for: .touchUpInside)
        return saveButton
    }()
    
    lazy var deleteButton: SaveButton = {
        let deleteButton = SaveButton("Delete")
        deleteButton.addTarget(viewController, action: #selector(AffiliationViewController.deleteAffiliation), for: .touchUpInside)
        return deleteButton
    }()
    
    var viewController: AffiliationViewController
    var affiliation: Affiliation
    
    init(viewController: AffiliationViewController) {
        self.viewController = viewController
        self.affiliation = viewController.affiliation
        super.init(frame: .zero)
        render()
    }
}

extension AffiliationView {
    func render() {
        constructHierarchy()
        activatConstraints()
        
        if viewController.editMode {
            prepopulateAffiliationFields()
        }
    }
    
    func prepopulateAffiliationFields() {
        role.text = affiliation.role
        organizationName.text = affiliation.organizationName
        
        fromButton.currentState.touched = true
        fromButton.currentState.set = true
        fromButton.currentState.date = affiliation.startDate
        fromButton.render()
        
        toButton.currentState.touched = true
        toButton.currentState.set = true
        toButton.currentState.date = affiliation.endDate
        toButton.render()
        
        if affiliation.endDate == "Present" {
            currentlyWorkHereToggle.isOn = true
        }
    }
    
    func constructHierarchy() {
        addSubview(mainTitle)
        addSubview(subtitle)
        addSubview(organizationName)
        addSubview(role)
        addSubview(saveButton)
        if viewController.editMode { addSubview(deleteButton) }
        addSubview(currentlyWorkHereLabel)
        addSubview(currentlyWorkHereToggle)
        addSubview(fromButton)
        addSubview(toButton)
        addSubview(toLabel)
        addSubview(fromLabel)
        addSubview(datePicker)
    }
    
    func activatConstraints() {
        mainTitle.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(50)
            make.width.equalToSuperview().inset(10)
        }
        
        subtitle.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(mainTitle.snp.bottom).offset(15)
            make.width.equalToSuperview().inset(10)
        }
        
        organizationName.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(15)
            make.top.equalTo(subtitle).offset(50)
        }
        
        role.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(15)
            make.top.equalTo(organizationName.snp.bottom).offset(10)
        }
        
        currentlyWorkHereLabel.snp.makeConstraints { (make) in
            make.left.equalTo(role)
            make.width.equalTo(200)
            make.top.equalTo(role.snp.bottom).offset(10)
        }
        
        currentlyWorkHereToggle.snp.makeConstraints { (make) in
            make.right.equalTo(role)
            make.centerY.equalTo(currentlyWorkHereLabel)
        }
        
        fromButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(20)
            make.width.equalTo(125)
            make.top.equalTo(currentlyWorkHereLabel).offset(75)
        }
        
        fromLabel.snp.makeConstraints { (make) in
            make.left.equalTo(fromButton)
            make.bottom.equalTo(fromButton.snp.top).offset(-5)
            make.width.equalTo(50)
        }
        
        toButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(20)
            make.width.equalTo(125)
            make.top.equalTo(currentlyWorkHereLabel).offset(75)
        }
        
        toLabel.snp.makeConstraints { (make) in
            make.left.equalTo(toButton)
            make.bottom.equalTo(toButton.snp.top).offset(-5)
            make.width.equalTo(50)
        }
        
        saveButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(30)
            make.height.equalTo(50)
            make.top.equalTo(toButton).offset(75)
        }
        
        if viewController.editMode {
            deleteButton.snp.makeConstraints { (make) in
                make.top.equalTo(saveButton).offset(75)
                make.centerX.equalToSuperview()
                make.width.equalToSuperview().inset(30)
                make.height.equalTo(50)
            }
        }
        
        datePicker.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(300)
            make.bottom.equalToSuperview().offset(300)
        }
    }
}
