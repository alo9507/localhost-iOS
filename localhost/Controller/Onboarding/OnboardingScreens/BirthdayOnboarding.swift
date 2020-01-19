//
//  BirthdayOnboarding.swift
//  Contact
//
//  Created by Andrew O'Brien on 12/26/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import UIKit
import SnapKit

class BirthdayOnboarding: OnboardingViewController {
    
    var birthday: String = ""
    
    let birthdayButton: DateButton = {
        let birthdayButton = DateButton("Birthday")
        birthdayButton.addTarget(self, action: #selector(dateRangeTapped(_:)), for: .touchUpInside)
        return birthdayButton
    }()
    
    let mustBe18Label: OnboardingLabel = {
        let mustBe18Label = OnboardingLabel()
        mustBe18Label.text = "You must be 18 or older to use localhost"
        return mustBe18Label
    }()
    
    lazy var datePicker: UIPickerView = {
        let datePicker = UIPickerView()
        return datePicker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.delegate = self
        datePicker.dataSource = self
        
        let ninetyFive: Int = Date.legalAgeYears.firstIndex(of: "1995")!
        
        datePicker.selectRow(5, inComponent: 0, animated: false)
        datePicker.selectRow(14, inComponent: 1, animated: false)
        datePicker.selectRow(ninetyFive, inComponent: 2, animated: false)
        
        birthdayButton.currentState.date = "6/15/1995"
        birthdayButton.render()
        
        nextButton.isActive = true
        
        render()
    }
    
    override func didFinishAppearanceTransition() {
        dateRangeTapped(birthdayButton)
    }
    
}

extension BirthdayOnboarding {
    func render() {
        inputContainer.addSubview(birthdayButton)
        inputContainer.addSubview(mustBe18Label)
        view.addSubview(datePicker)
        
        birthdayButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalTo(300)
        }
        
        mustBe18Label.snp.makeConstraints { (make) in
            make.top.equalTo(birthdayButton.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.width.equalTo(birthdayButton.snp.width)
        }
        
        datePicker.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(300)
            make.bottom.equalToSuperview().offset(300)
        }
        
        inputContainer.resizeToFitSubviews()
    }
    
    @objc
    func dateRangeTapped(_ sender: DateButton) {
        birthdayButton.currentState.touched = false
        birthdayButton.currentState.focused = false
        if birthdayButton.currentState.date != "Present" && birthdayButton.currentState.date != "To" && birthdayButton.currentState.date != "From" {
            birthdayButton.currentState.set = true
        }
        
        birthdayButton.currentState.touched = true
        birthdayButton.currentState.focused = true
        birthdayButton.render()
        view.endEditing(true)
        showDatePicker()
    }
    
    private func showDatePicker() {
        self.pickerViewWillShow(self.datePicker)
        
        UIView.animate(withDuration: 0.23) {
            self.datePicker.snp.updateConstraints { (update) in
                update.bottom.equalToSuperview()
            }
            self.view.layoutIfNeeded()
        }
    }
    
    private func hideDatePicker() {
        self.pickerViewWillHide(self.datePicker)
        birthdayButton.currentState.focused = false
        birthdayButton.render()
        
        UIView.animate(withDuration: 0.23) {
            self.datePicker.snp.updateConstraints { (update) in
                update.bottom.equalToSuperview().offset(300)
            }
            self.view.layoutIfNeeded()
        }
    }
}

extension BirthdayOnboarding {
    func isValid() -> Bool {
        return birthdayButton.titleLabel?.text != "Birthday"
    }
}

extension BirthdayOnboarding: UIPickerViewDelegate, UIPickerViewDataSource {
    func isMonthComponent(_ component: Int) -> Bool { return component == 0 }
    func isDayComponent(_ component: Int) -> Bool { return component == 1 }
    func isYearComponent(_ component: Int) -> Bool { return component == 2 }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if isMonthComponent(component) {
            return Date.months.count
        }
        if isDayComponent(component) {
            return Date.days.count
        }
        if isYearComponent(component) {
            return Date.legalAgeYears.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var monthDayYear: String = ""
        
        if isMonthComponent(component) {
            let integerMonth = Date.months.firstIndex(of: Date.months[row])! + 1
            let dayIndex = pickerView.selectedRow(inComponent: 1)
            let yearIndex = pickerView.selectedRow(inComponent: 2)
            
            monthDayYear = "\(String(integerMonth))/\(Date.days[dayIndex])/\(Date.legalAgeYears[yearIndex])"
        }
        if isDayComponent(component) {
            let monthIndex = pickerView.selectedRow(inComponent: 0)
            let yearIndex = pickerView.selectedRow(inComponent: 2)
            
            let integerMonth = String(Date.months.firstIndex(of: Date.months[monthIndex])! + 1)
            
            monthDayYear = "\(integerMonth)/\(Date.days[row])/\(Date.legalAgeYears[yearIndex])"
        }
        if isYearComponent(component) {
            let monthIndex = pickerView.selectedRow(inComponent: 0)
            let dayIndex = pickerView.selectedRow(inComponent: 1)
            
            let integerMonth = String(Date.months.firstIndex(of: Date.months[monthIndex])! + 1)
            
            monthDayYear = "\(integerMonth)/\(Date.days[dayIndex])/\(Date.legalAgeYears[row])"
        }
        
        birthdayButton.currentState.date = monthDayYear
        birthdayButton.currentState.set = true
        birthdayButton.render()
        
        self.birthday = monthDayYear
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var string: String = ""
        
        if isMonthComponent(component) {
            string = Date.months[row]
            return NSAttributedString(string: string, attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.lhPink,
                NSAttributedString.Key.font: Fonts.avenirNext_bold(30)
            ])
        }
        if isDayComponent(component) {
            string = Date.days[row]
            return NSAttributedString(string: string, attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.white,
                NSAttributedString.Key.font: Fonts.avenirNext_bold(30)
            ])
        }
        if isYearComponent(component) {
            string = Date.legalAgeYears[row]
            return NSAttributedString(string: string, attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.lhYellow,
                NSAttributedString.Key.font: Fonts.avenirNext_bold(30)
            ])
        }
        return NSAttributedString(string: string, attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.lhYellow,
            NSAttributedString.Key.font: Fonts.avenirNext_bold(30)
        ])
    }
}

