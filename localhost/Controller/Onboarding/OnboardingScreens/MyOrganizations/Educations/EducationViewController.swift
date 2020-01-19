//
//  AddEducationViewController.swift
//  Contact
//
//  Created by Andrew O'Brien on 12/25/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//
import UIKit

protocol EducationDelegate: class {
    func didAddEducation(_ education: Education)
    func didEditEducation(_ editedEducation: Education, _ educationDescription: EducationDescription)
    func showEditEducation(_ educationDescription: EducationDescription)
}

class EducationViewController: NiblessViewController {
    var degrees: [Degree] = [.highschool, .ba, .bs, .mba, .phd, .masters, .bfa]
    
    var delegate: EducationDelegate?
    var chosenDegree: Degree?
    
    var yearsTillNow: [String] {
        var years = [String]()
        
        for year in (1950...Date.currentYear() + 10).reversed() {
            years.append("\(year)")
        }
        
        return years
    }
    
    let mainTitle: OnboardingTitleLabel = OnboardingTitleLabel("where have you studied?")
    
    let schoolNameTextField: OnboardingTextField = OnboardingTextField(placeholder: "School Name", keyboardType: .default, returnKeyType: .next)
    
    lazy var degreeTextField: OnboardingTextField = {
        let degreeTextField = OnboardingTextField(placeholder: "Degree", keyboardType: .default, returnKeyType: .next)
        degreeTextField.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(degreeTapped(_:))))
        degreeTextField.delegate = self
        return degreeTextField
    }()
    
    let majorTextField: OnboardingTextField = OnboardingTextField(placeholder: "Major", keyboardType: .default, returnKeyType: .next)
    let minorTextField: OnboardingTextField = OnboardingTextField(placeholder: "Minor", keyboardType: .default, returnKeyType: .next)
    
    let classYearButton: DateButton = {
        let fromField = DateButton("Class Year")
        fromField.addTarget(self, action: #selector(dateRangeTapped(_:)), for: .touchUpInside)
        return fromField
    }()
    
    let saveButton: SaveButton = {
        let saveButton = SaveButton("Save")
        saveButton.addTarget(self, action: #selector(addOrEditEducation), for: .touchUpInside)
        return saveButton
    }()
    
    lazy var degreePicker: UIPickerView = {
        let degreePicker = UIPickerView()
        return degreePicker
    }()
    
    lazy var yearPicker: UIPickerView = {
        let yearPicker = UIPickerView()
        return yearPicker
    }()
    
    var selectedDateInput: DateButton!
    
    override init() {
        self.education = Education(school: "", degree: .ba, major: "", minor: "", graduationYear: "")
        
        super.init()
        view.backgroundColor = UIColor.init(hexString: "#4450C7", withAlpha: 1.0)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideInputs(_:)))
        tapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGesture)
        render()
    }
    
    var editMode: Bool = false
    var educationDescription: EducationDescription?
    var education: Education
    
    convenience init(_ education: Education, editMode: Bool, educationDescription: EducationDescription) {
        self.init()
        self.education = education
        self.editMode = editMode
        self.educationDescription = educationDescription
        
        self.majorTextField.text = education.major
        self.minorTextField.text = education.minor
        self.schoolNameTextField.text = education.school
    }
    
    override func viewDidAppear(_ animated: Bool) {
        schoolNameTextField.becomeFirstResponder()
        schoolNameTextField.delegate = self
        majorTextField.delegate = self
        minorTextField.delegate = self
        
        degreePicker.delegate = self
        degreePicker.dataSource = self
        
        yearPicker.delegate = self
        yearPicker.dataSource = self
    }
    
}

extension EducationViewController {
    func render() {
        constructHierarchy()
        activatConstraints()
    }
    
    func constructHierarchy() {
        view.addSubview(mainTitle)
        view.addSubview(schoolNameTextField)
        view.addSubview(degreeTextField)
        view.addSubview(majorTextField)
        view.addSubview(minorTextField)
        view.addSubview(saveButton)
        view.addSubview(classYearButton)
        view.addSubview(yearPicker)
        view.addSubview(degreePicker)
    }
    
    func activatConstraints() {
        mainTitle.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(50)
            make.width.equalToSuperview().inset(10)
        }
        
        schoolNameTextField.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(15)
            make.top.equalTo(mainTitle).offset(50)
        }
        
        degreeTextField.snp.makeConstraints { (make) in
            make.left.equalTo(schoolNameTextField)
            make.width.equalTo(80)
            make.top.equalTo(schoolNameTextField.snp.bottom).offset(10)
        }
        
        majorTextField.snp.makeConstraints { (make) in
            make.left.equalTo(degreeTextField.snp.right).offset(5)
            make.right.equalTo(schoolNameTextField.snp.right)
            make.top.equalTo(schoolNameTextField.snp.bottom).offset(10)
        }
        
        minorTextField.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(15)
            make.top.equalTo(majorTextField.snp.bottom).offset(10)
        }
        
        classYearButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalTo(300)
            make.top.equalTo(minorTextField).offset(75)
        }
        
        saveButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(30)
            make.height.equalTo(50)
            make.top.equalTo(classYearButton).offset(75)
        }
        
        yearPicker.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(300)
            make.bottom.equalToSuperview().offset(300)
        }
        
        degreePicker.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(300)
            make.bottom.equalToSuperview().offset(300)
        }
    }
}

extension EducationViewController {
    @objc
    func addOrEditEducation() {
        let education = Education(school: schoolNameTextField.text ?? "", degree: chosenDegree  ?? .ba, major: majorTextField.text  ?? "", minor: minorTextField.text  ?? "", graduationYear: classYearButton.titleLabel!.text  ?? "")
        
        if self.editMode {
            guard let educationDescription = self.educationDescription else {
                fatalError("No education desc but you're editing it?")
            }
            self.delegate?.didEditEducation(education, educationDescription)
        } else {
            self.delegate?.didAddEducation(education)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc
    func hideInputs(_ sender: UIView) {
        self.view.endEditing(true)
        hideYearPicker()
    }
    
    @objc
    func dateRangeTapped(_ sender: DateButton) {
        if (selectedDateInput != nil) {
            selectedDateInput.currentState.touched = false
            selectedDateInput.currentState.focused = false
            if selectedDateInput.currentState.date != "Present" && selectedDateInput.currentState.date != "To" && selectedDateInput.currentState.date != "From" {
                selectedDateInput.currentState.set = true
            }
        }
        
        selectedDateInput = sender
        
        selectedDateInput.currentState.touched = true
        selectedDateInput.currentState.focused = true
        selectedDateInput.render()
        view.endEditing(true)
        
        let index = yearsTillNow.firstIndex(of: "2018")
        
        yearPicker.selectRow(index!, inComponent: 0, animated: false)
        showYearPicker()
    }
    
    @objc
    func currentlyWorksHere(_ toggle: UISwitch) {
        classYearButton.currentState.touched = true
        if toggle.isOn {
            classYearButton.currentState.date = "Present"
            classYearButton.currentState.focused = false
            classYearButton.currentState.set = true
        } else {
            classYearButton.currentState.date = "Class Year"
            classYearButton.currentState.focused = false
            classYearButton.currentState.set = false
        }
        classYearButton.render()
    }
    
    private func showYearPicker() {
        hideDegreePicker()
        UIView.animate(withDuration: 0.23) {
            self.yearPicker.snp.updateConstraints { (update) in
                update.bottom.equalToSuperview()
            }
            self.view.layoutIfNeeded()
        }
    }
    
    private func hideYearPicker() {
        if selectedDateInput != nil {
            selectedDateInput.currentState.focused = false
            selectedDateInput.render()
        }
        
        UIView.animate(withDuration: 0.23) {
            self.yearPicker.snp.updateConstraints { (update) in
                update.bottom.equalToSuperview().offset(300)
            }
            self.view.layoutIfNeeded()
        }
    }
    
    @objc
    func degreeTapped(_ sender: UITextField) {
        showDegreePicker()
    }
    
    private func showDegreePicker() {
        hideYearPicker()
        self.view.endEditing(true)
        UIView.animate(withDuration: 0.23) {
            self.degreePicker.snp.updateConstraints { (update) in
                update.bottom.equalToSuperview()
            }
            self.view.layoutIfNeeded()
        }
    }
    
    private func hideDegreePicker() {
        UIView.animate(withDuration: 0.23) {
            self.degreePicker.snp.updateConstraints { (update) in
                update.bottom.equalToSuperview().offset(300)
            }
            self.view.layoutIfNeeded()
        }
    }
}

extension EducationViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField === degreeTextField {
            return false
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.hideDegreePicker()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === schoolNameTextField {
            degreeTapped(degreeTextField)
        }
        if textField === majorTextField {
            minorTextField.becomeFirstResponder()
        }
        if textField === minorTextField {
            dateRangeTapped(classYearButton)
        }
        return false
    }
}

extension EducationViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView === degreePicker {
            return degrees.count
        }
        if pickerView === yearPicker {
            return yearsTillNow.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView === degreePicker {
            self.chosenDegree = degrees[row]
            degreeTextField.text = chosenDegree?.rawValue
            
            if self.chosenDegree == .highschool {
                self.majorTextField.isHidden = true
                self.minorTextField.isHidden = true
                UIView.animate(withDuration: 0.23) {
                    self.degreeTextField.snp.updateConstraints { (update) in
                        update.width.equalTo(160)
                    }
                    self.view.layoutIfNeeded()
                }
            } else {
                self.majorTextField.isHidden = false
                self.minorTextField.isHidden = false
            }
        }
        if pickerView === yearPicker {
            classYearButton.currentState.date = yearsTillNow[row]
            classYearButton.currentState.set = true
            classYearButton.render()
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var string: String = ""
        if pickerView === degreePicker {
            string = degrees[row].rawValue
        }
        if pickerView === yearPicker {
            string = yearsTillNow[row]
        }
        
        return NSAttributedString(string: string, attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: Fonts.avenirNext_bold(30)
        ])
    }
}


