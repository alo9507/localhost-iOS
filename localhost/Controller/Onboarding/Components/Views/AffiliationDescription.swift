//
//  AffiliationDescription.swift
//  Contact
//
//  Created by Andrew O'Brien on 12/14/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import UIKit
import SnapKit

class AffiliationDescription: EditableStackViewItem {
    let affiliation: Affiliation
    weak var delegate: AffiliationDelegate?
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 400, height: 80)
    }
    
    lazy var organizationNameLabel: UILabel = {
        let organizationNameLabel = UILabel()
        organizationNameLabel.text = "\(affiliation.role) @ \(affiliation.organizationName)"
        organizationNameLabel.numberOfLines = 0
        organizationNameLabel.sizeToFit()
        organizationNameLabel.textColor = .white
        organizationNameLabel.font = Fonts.avenirNext_bold(18)
        return organizationNameLabel
    }()
    
    lazy var roleLabel: UILabel = {
        let roleLabel = UILabel()
        roleLabel.text = affiliation.role
        roleLabel.numberOfLines = 0
        roleLabel.sizeToFit()
        roleLabel.textColor = .white
        roleLabel.font = Fonts.avenirNext_bold(16)
        return roleLabel
    }()
    
    lazy var dateRangeLabel: UILabel = {
        let dateRangeLabel = UILabel()
        dateRangeLabel.text = "\(affiliation.startDate) - \(affiliation.endDate)"
        dateRangeLabel.numberOfLines = 0
        dateRangeLabel.textColor = .white
        dateRangeLabel.font = Fonts.avenirNext_demibold(16)
        dateRangeLabel.sizeToFit()
        return dateRangeLabel
    }()
    
    lazy var editLabel: UIButton = {
        let editLabel = UIButton()
        editLabel.setBackgroundImage(UIImage(named: "pencil-edit-button"), for: .normal)
        editLabel.addTarget(self, action: #selector(editAffiliation), for: .touchUpInside)
        return editLabel
    }()
    
    let showEditIcon: Bool
    
    init(_ affiliation: Affiliation, showEditIcon: Bool = true) {
        self.affiliation = affiliation
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
        addSubview(organizationNameLabel)
//        addSubview(roleLabel)
        addSubview(dateRangeLabel)
        if showEditIcon { addSubview(editLabel) }
    }
    
    func activateConstraints() {
        organizationNameLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
        }
        
//        roleLabel.snp.makeConstraints { (make) in
//            make.top.equalTo(organizationNameLabel.snp.bottom)
//            make.left.equalTo(organizationNameLabel)
//        }
        
        dateRangeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(organizationNameLabel.snp.bottom)
            make.left.equalTo(organizationNameLabel)
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

extension AffiliationDescription {
    @objc
    func editAffiliation() {
        self.delegate?.showEditAffiliation(self)
    }
}
