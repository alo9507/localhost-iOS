//
//  MyOrganizationsOnboardingViewController.swift
//  Contact
//
//  Created by Andrew O'Brien on 12/13/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import UIKit
import SnapKit

class MyOrganizationsOnboardingViewController: OnboardingViewController {
    
    lazy var addAffiliationsButton: UIButton = {
        let addAffiliationsButton = UIButton()
        let attributedTitle = NSAttributedString(string: "+ Add Affiliations", attributes: [
            NSAttributedString.Key.foregroundColor : UIColor.lhPink,
            NSAttributedString.Key.font: Fonts.avenirNext_demibold(24)
        ])
        
        addAffiliationsButton.layer.borderColor = UIColor.lhPink.cgColor
        addAffiliationsButton.layer.borderWidth = 4
        addAffiliationsButton.layer.cornerRadius = 20
        addAffiliationsButton.sizeToFit()
        
        addAffiliationsButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        addAffiliationsButton.setAttributedTitle(attributedTitle, for: .normal)
        addAffiliationsButton.addTarget(self, action: #selector(showAddAffiliation), for: .touchUpInside)
        return addAffiliationsButton
    }()
    
    lazy var addEducationButton: UIButton = {
        let addEducationButton = UIButton()
        let attributedTitle = NSAttributedString(string: "+ Add Education", attributes: [
            NSAttributedString.Key.foregroundColor : UIColor.lhPink,
            NSAttributedString.Key.font: Fonts.avenirNext_demibold(24)
        ])
        
        addEducationButton.layer.borderColor = UIColor.lhPink.cgColor
        addEducationButton.layer.borderWidth = 4
        addEducationButton.layer.cornerRadius = 20
        addEducationButton.sizeToFit()
        addEducationButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        addEducationButton.setAttributedTitle(attributedTitle, for: .normal)
        addEducationButton.addTarget(self, action: #selector(showAddEducation), for: .touchUpInside)
        return addEducationButton
    }()
    
    lazy var affiliationsStackView: MyOrganizationsStackView = {
        let affiliationsStackView = MyOrganizationsStackView()
        affiliationsStackView.insertArrangedSubview(addAffiliationsButton, at: 0)
        return affiliationsStackView
    }()
    
    lazy var educationStackView: MyOrganizationsStackView = {
        let educationStackView = MyOrganizationsStackView()
        educationStackView.insertArrangedSubview(addEducationButton, at: 0)
        return educationStackView
    }()
    
    lazy var myOrganizationsStackView: MyOrganizationsStackView = {
        let myOrganizationsStackView = MyOrganizationsStackView()
        myOrganizationsStackView.insertArrangedSubview(affiliationsStackView, at: 0)
        myOrganizationsStackView.insertArrangedSubview(educationStackView, at: 1)
        
        myOrganizationsStackView.layoutIfNeeded()
        
        return myOrganizationsStackView
    }()
    
    var affiliations: [Affiliation] = []
    var educations: [Education] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.isActive = true
        render()
    }
}

extension MyOrganizationsOnboardingViewController {
    func render() {
        constructHierarchy()
        activateConstrains()
    }
    
    func constructHierarchy() {
        inputContainer.addSubview(myOrganizationsStackView)
    }
    
    func activateConstrains() {
        myOrganizationsStackView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        addAffiliationsButton.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
        }
        
        addEducationButton.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
        }
    }
}

extension MyOrganizationsOnboardingViewController: AffiliationDelegate {
    @objc
    func showAddAffiliation() {
        let affiliationViewController = AffiliationViewController()
        affiliationViewController.delegate = self
        self.present(affiliationViewController, animated: true)
    }
    
    func showEditAffiliation(_ affiliationDescription: AffiliationDescription) {
        let editAffiliationVC = AffiliationViewController(affiliationDescription.affiliation, editMode: true, affiliationDescription: affiliationDescription)
        editAffiliationVC.delegate = self
        self.present(editAffiliationVC, animated: true)
    }
    
    func didAddAffiliation(_ affiliation: Affiliation) {
        affiliations.append(affiliation)
        let affiliationDescription = AffiliationDescription(affiliation)
        affiliationDescription.delegate = self
        affiliationsStackView.insertArrangedSubview(affiliationDescription, at: 1)
        
        for (index, affiliationDescription) in affiliationsStackView.arrangedSubviews.enumerated() {
            guard let description = affiliationDescription as? AffiliationDescription else {
                continue
            }
            description.index = index
        }
        
        affiliationsStackView.layoutIfNeeded()
        myOrganizationsStackView.layoutIfNeeded()
    }
    
    func didEditAffiliation(_ editedAffiliation: Affiliation, _ affiliationDescription: AffiliationDescription) {
        guard let index = affiliations.firstIndex(of: affiliationDescription.affiliation) else {
            fatalError()
        }
        affiliations.remove(at: index)
        self.affiliationsStackView.removeArrangedSubview(affiliationDescription)
        affiliationDescription.removeFromSuperview()
        self.didAddAffiliation(editedAffiliation)
    }
    
    func didDeleteAffiliation(_ deletedAffiliation: Affiliation, _ affiliationDescription: AffiliationDescription) {
        guard let index = affiliations.firstIndex(of: deletedAffiliation) else {
            fatalError()
        }
        affiliations.remove(at: index)
        self.affiliationsStackView.removeArrangedSubview(affiliationDescription)
        affiliationDescription.removeFromSuperview()
    }
}

// Strategy Pattern might work for this
extension MyOrganizationsOnboardingViewController: EducationDelegate {
    @objc
    func showAddEducation() {
        let addEducationVC = EducationViewController()
        addEducationVC.delegate = self
        self.present(addEducationVC, animated: true)
    }
    
    @objc
    func showEditEducation(_ educationDescription: EducationDescription) {
        let editEducationVC = EducationViewController(educationDescription.education, editMode: true, educationDescription: educationDescription)
        editEducationVC.delegate = self
        self.present(editEducationVC, animated: true)
    }
    
    func didAddEducation(_ education: Education) {
        educations.append(education)
        
        let educationDescription = EducationDescription(education)
        educationDescription.delegate = self
        educationStackView.insertArrangedSubview(educationDescription, at: 1)
        
        educationStackView.layoutIfNeeded()
        myOrganizationsStackView.layoutIfNeeded()
    }
    
    func didEditEducation(_ editedEducation: Education, _ educationDescription: EducationDescription) {
        guard let index = educations.firstIndex(of: educationDescription.education) else {
            fatalError()
        }
        educations.remove(at: index)
        self.educationStackView.removeArrangedSubview(educationDescription)
        educationDescription.removeFromSuperview()
        self.didAddEducation(editedEducation)
    }
}
