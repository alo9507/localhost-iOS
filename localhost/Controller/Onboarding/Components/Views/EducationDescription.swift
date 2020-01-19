//
//  EducationDescription.swift
//  Contact
//
//  Created by Andrew O'Brien on 12/25/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import UIKit
import SnapKit

class EducationDescription: UIView {
    let education: Education
    
    weak var delegate: EducationDelegate?
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 400, height: 80)
    }
    
    lazy var schoolNameLabel: UILabel = {
        let schoolNameLabel = UILabel()
        schoolNameLabel.text = education.school
        schoolNameLabel.numberOfLines = 0
        schoolNameLabel.sizeToFit()
        schoolNameLabel.textColor = .white
        schoolNameLabel.font = Fonts.avenirNext_bold(18)
        return schoolNameLabel
    }()
    
    lazy var majorLabel: UILabel = {
        let majorLabel = UILabel()
        majorLabel.text = education.major
        majorLabel.numberOfLines = 0
        majorLabel.sizeToFit()
        majorLabel.textColor = .white
        majorLabel.font = Fonts.avenirNext_bold(16)
        return majorLabel
    }()
    
    lazy var minorLabel: UILabel = {
        let minorLabel = UILabel()
        minorLabel.text = education.minor
        minorLabel.numberOfLines = 0
        minorLabel.sizeToFit()
        minorLabel.textColor = .white
        minorLabel.font = Fonts.avenirNext_bold(16)
        return minorLabel
    }()
    
    lazy var classYearLabel: UILabel = {
        let classYearLabel = UILabel()
        classYearLabel.text = education.graduationYear
        classYearLabel.numberOfLines = 0
        classYearLabel.textColor = .white
        classYearLabel.font = Fonts.avenirNext_demibold(16)
        classYearLabel.sizeToFit()
        return classYearLabel
    }()
    
    lazy var degreeLabel: UILabel = {
        let degreeLabel = UILabel()
        degreeLabel.text = education.degree.rawValue
        degreeLabel.numberOfLines = 0
        degreeLabel.textColor = .white
        degreeLabel.font = Fonts.avenirNext_demibold(16)
        degreeLabel.sizeToFit()
        return degreeLabel
    }()
    
    lazy var editLabel: UIButton = {
        let editLabel = UIButton()
        editLabel.setBackgroundImage(UIImage(named: "pencil-edit-button"), for: .normal)
        editLabel.addTarget(self, action: #selector(showEditEducation), for: .touchUpInside)
        return editLabel
    }()
    
    let showEditIcon: Bool
    
    init(_ education: Education, showEditIcon: Bool = true) {
        self.education = education
        self.showEditIcon = showEditIcon
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        render()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func render() {
        constructHierarchy()
        activateConstraints()
    }
    
    func constructHierarchy() {
        addSubview(schoolNameLabel)
        addSubview(majorLabel)
        addSubview(minorLabel)
        addSubview(degreeLabel)
        addSubview(classYearLabel)
        if showEditIcon { addSubview(editLabel) }
    }
    
    func activateConstraints() {
        schoolNameLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
        }
        
        classYearLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(schoolNameLabel)
            make.left.equalTo(schoolNameLabel.snp.right).offset(50)
        }
        
        degreeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(schoolNameLabel.snp.bottom)
            make.left.equalTo(schoolNameLabel)
        }
        
        majorLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(degreeLabel)
            make.left.equalTo(degreeLabel.snp.right).offset(50)
        }
        
        minorLabel.snp.makeConstraints { (make) in
            make.top.equalTo(majorLabel.snp.bottom)
            make.left.equalTo(schoolNameLabel)
        }
        
        if showEditIcon {
            editLabel.snp.makeConstraints { (make) in
                make.right.equalToSuperview()
                make.top.equalToSuperview().offset(5)
                make.width.height.equalTo(20)
            }
        }
    }
}

extension EducationDescription {
    @objc
    func showEditEducation() {
        self.delegate?.showEditEducation(self)
    }
}
