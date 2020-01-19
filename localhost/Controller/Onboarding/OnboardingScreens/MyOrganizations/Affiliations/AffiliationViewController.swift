//
//  AddAffiliation.swift
//  Contact
//
//  Created by Andrew O'Brien on 12/13/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import UIKit

class AffiliationViewController: NiblessViewController {
    var affiliation: Affiliation
    var editMode: Bool = false
    var delegate: AffiliationDelegate?
    var affiliationDescription: AffiliationDescription?
    var selectedDateInput: DateButton?
    
    public var affiliationView: AffiliationView! {
        guard isViewLoaded else { return nil }
        return (view as! AffiliationView)
    }
    
    override init() {
        self.affiliation = Affiliation(
            organizationName: "",
            role: "",
            startDate: "From",
            endDate: "To")
        
        super.init()
    }
    
    // Edit Affiliation Convenience Init
    convenience init(
        _ affiliation: Affiliation,
        editMode: Bool,
        affiliationDescription: AffiliationDescription) {
        self.init()
        
        self.affiliation = affiliation
        self.editMode = editMode
        self.affiliationDescription = affiliationDescription
    }
    
    override func viewDidAppear(_ animated: Bool) {
        affiliationView.organizationName.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideInputs(_:)))
        tapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGesture)
        view.backgroundColor = UIColor.init(hexString: "#4450C7", withAlpha: 1.0)
        
        affiliationView.organizationName.delegate = self
        affiliationView.role.delegate = self
    }
    
    override func loadView() {
        self.view = AffiliationView(viewController: self)
    }
    
}

extension AffiliationViewController {
    @objc
    func hideInputs(_ sender: UIView) {
        self.view.endEditing(true)
        hideDatePicker()
    }
    
    private func showDatePicker() {
        self.view.endEditing(true)
        UIView.animate(withDuration: 0.23) {
            self.affiliationView.datePicker.snp.updateConstraints { (update) in
                update.bottom.equalToSuperview()
            }
            self.view.layoutIfNeeded()
        }
    }
    
    private func hideDatePicker() {
        if let selectedDateInput = selectedDateInput {
            selectedDateInput.currentState.focused = false
            selectedDateInput.render()
        }
        
        UIView.animate(withDuration: 0.23) {
            self.affiliationView.datePicker.snp.updateConstraints { (update) in
                update.bottom.equalToSuperview().offset(300)
            }
            self.view.layoutIfNeeded()
        }
    }
    
    @objc
    func deleteAffiliation() {
        guard let affiliationDescription = self.affiliationDescription else {
            fatalError("No affiliation desc but you're editing it?")
        }
        self.delegate?.didDeleteAffiliation(affiliation, affiliationDescription)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc
    func addOrEditAffiliation() {
        let affiliation = Affiliation(
            organizationName: affiliationView.organizationName.text!,
            role: affiliationView.role.text!,
            startDate: affiliationView.fromButton.titleLabel!.text!,
            endDate: affiliationView.toButton.titleLabel!.text!)
        
        switch isValid(affiliation) {
            case .startDateLessThanEndDate:
                let message = affiliation.organizationName == "" ? "Start date must be later than end date" : "You started working at \(affiliation.organizationName) after you stopped working there? Whoa!"
                let alert = UIAlertController(title: "Impossible Dates!", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK!", style: .cancel, handler: { (action) in
                    self.dateRangeTapped(self.affiliationView.toButton)
                }))
                self.present(alert, animated: true, completion: nil)
            case .noRoleOrOrganization:
                let alert = UIAlertController(title: "No Role or Organization?", message: "What organizations have you been a part of?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK!", style: .cancel, handler: { (action) in
                    self.affiliationView.organizationName.becomeFirstResponder()
                }))
                self.present(alert, animated: true, completion: nil)
            case .noRole:
                let alert = UIAlertController(title: "No Role?", message: "What did you do at \(affiliation.organizationName)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK!", style: .cancel, handler: { (action) in
                    self.affiliationView.role.becomeFirstResponder()
                }))
                self.present(alert, animated: true, completion: nil)
            case .noOrganization:
                let alert = UIAlertController(title: "Missing Role?", message: "In what organization were you a \(affiliation.role)?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            case .noStartDate:
                let alert = UIAlertController(title: "No Start Date?", message: "When did you start working here?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK!", style: .cancel, handler: { (action) in
                    self.affiliationView.role.becomeFirstResponder()
                }))
                self.present(alert, animated: true, completion: nil)
            case .noEndDate:
                let alert = UIAlertController(title: "No End Date?", message: "When did you stop working here?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK!", style: .cancel, handler: { (action) in
                    self.dateRangeTapped(self.affiliationView.toButton)
                }))
                self.present(alert, animated: true, completion: nil)
            case .noStartDateOrEndDate:
                let alert = UIAlertController(title: "No Start or End Date?", message: "When did you work here?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK!", style: .cancel, handler: { (action) in
                    self.dateRangeTapped(self.affiliationView.fromButton)
                }))
                self.present(alert, animated: true, completion: nil)
            case .valid:
                if self.editMode {
                    guard let affiliationDescription = self.affiliationDescription else {
                        fatalError("No affiliation desc but you're editing it?")
                    }
                    self.delegate?.didEditAffiliation(affiliation, affiliationDescription)
                } else {
                    self.delegate?.didAddAffiliation(affiliation)
                }
                self.dismiss(animated: true, completion: nil)
        }
    }
    
    enum AffiliationValidationResult {
        case startDateLessThanEndDate
        case noRole
        case noOrganization
        case noRoleOrOrganization
        case noStartDate
        case noEndDate
        case noStartDateOrEndDate
        case valid
    }
    
    func isValid(_ affiliation: Affiliation) -> AffiliationValidationResult {
        if affiliation.organizationName == "" && affiliation.role == "" { return .noRoleOrOrganization }
        if affiliation.organizationName == "" { return .noOrganization }
        if affiliation.role == "" { return .noRole }
        
        let invalidDates = ["", "From", "To"]
        
        if invalidDates.contains(affiliation.startDate) && invalidDates.contains(affiliation.endDate) { return .noStartDateOrEndDate }
        if invalidDates.contains(affiliation.startDate) { return .noStartDate }
        if invalidDates.contains(affiliation.endDate) { return .noEndDate }
        
        guard let startDate = Date.dateFromString(affiliation.startDate, "MM-yyyy") else { fatalError() }
        if affiliation.endDate != "Present" {
            guard let endDate = Date.dateFromString(affiliation.endDate, "MM-yyyy") else { fatalError("End date?") }
            
            let startDateLessThanEndDate = startDate.months(from: endDate) > 0
            if startDateLessThanEndDate {
                return .startDateLessThanEndDate
            }
        }
        
        return .valid
    }
    
    func isSet(_ string: String?) -> Bool {
        guard string != nil else { return false }
        return string != "To" && string != "From"
    }
    
    func configureSelectedDate(_ sender: DateButton) {
        guard let previouslySelectedDate = self.selectedDateInput else {
            // NO PREVIOUS SELECTION
            self.selectedDateInput = sender
            self.selectedDateInput!.currentState.focused = true
            self.selectedDateInput!.currentState.touched = true
            self.selectedDateInput!.render()
            return
        }
        
        // DESELECT PREVIOUS DATE BUTTON
        previouslySelectedDate.currentState.touched = true
        previouslySelectedDate.currentState.focused = false
        previouslySelectedDate.currentState.set = isSet(previouslySelectedDate.currentState.date)
        previouslySelectedDate.render()
        
        // SELECT CURRENT DATE BUTTON
        // why the fuck does sender have the same date as selectedDateInput
        self.selectedDateInput = sender
        selectedDateInput!.currentState.focused = true
        self.selectedDateInput!.currentState.touched = true
        selectedDateInput!.render()
    }
    
    func configureDatePicker() {
        // THIS WAS JUST SET IN PREVIOUS METHOD
        guard let selectedDateInput = self.selectedDateInput else {
            fatalError()
        }
        
        if selectedDateInput.currentState.set {
            guard let date = Date.dateFromString(self.selectedDateInput!.currentState.date!, "MM-yyyy") else {
                return print("this will work after error checking")
            }
            
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year], from: date)
            let year = components.year
            let yearIndex = Date.yearsTillNow.firstIndex(of: String(year!))!
                
            affiliationView.datePicker.selectRow(date.month - 1, inComponent: 0, animated: false)
            affiliationView.datePicker.selectRow(yearIndex, inComponent: 1, animated: false)
        } else {
            // 03/2018
            let twentyEighteenIndex = Date.yearsTillNow.firstIndex(of: "2018")!
            affiliationView.datePicker.selectRow(2, inComponent: 0, animated: false)
            affiliationView.datePicker.selectRow(twentyEighteenIndex, inComponent: 1, animated: false)
        }
    }
    
    @objc
    func dateRangeTapped(_ sender: DateButton) {
        view.endEditing(true)
        configureSelectedDate(sender)
        configureDatePicker()
        showDatePicker()
    }
    
    @objc
    func currentlyWorksHere(_ toggle: UISwitch) {
        affiliationView.toButton.currentState.touched = true
        if toggle.isOn {
            affiliationView.toButton.currentState.date = "Present"
            affiliationView.toButton.currentState.touched = true
            affiliationView.toButton.currentState.focused = false
            affiliationView.toButton.currentState.set = true
            affiliationView.toButton.currentState.valid = true
        } else {
            affiliationView.toButton.currentState.date = "To"
            affiliationView.toButton.currentState.touched = false
            affiliationView.toButton.currentState.focused = false
            affiliationView.toButton.currentState.set = false
            affiliationView.toButton.currentState.valid = true
        }
        affiliationView.toButton.render()
    }
}

extension AffiliationViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func isYearComponent(_ component: Int) -> Bool { return component == 1 }
    func isMonthComponent(_ component: Int) -> Bool { return component == 0 }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if isMonthComponent(component) { return Date.months.count }
        if isYearComponent(component) { return Date.yearsTillNow.count }
        fatalError()
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let selectedDateInput = self.selectedDateInput else { fatalError() }
        
        var monthYear: String = ""
        
        if isMonthComponent(component) {
            let month = String(row + 1)
            let yearIndex = pickerView.selectedRow(inComponent: 1)
            let year = Date.yearsTillNow[yearIndex]
            monthYear = "\(month)/\(year)"
        }
        
        if isYearComponent(component) {
            let month = String(pickerView.selectedRow(inComponent: 0) + 1)
            let year = Date.yearsTillNow[row]
            monthYear = "\(month)/\(year)"
        }

        selectedDateInput.currentState.date = monthYear
        selectedDateInput.currentState.set = true
        selectedDateInput.render()
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var tile: String = ""
        
        if isMonthComponent(component) { tile = Date.months[row] }
        if isYearComponent(component) { tile = Date.yearsTillNow[row] }
        
        return NSAttributedString(string: tile, attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: Fonts.avenirNext_bold(30)
        ])
    }
}

extension AffiliationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === affiliationView.organizationName {
            affiliationView.role.becomeFirstResponder()
        }
        if textField === affiliationView.role {
            dateRangeTapped(affiliationView.fromButton)
        }
        return false
    }
}
