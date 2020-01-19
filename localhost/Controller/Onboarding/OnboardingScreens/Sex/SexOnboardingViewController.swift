//
//  SexOnboardingViewController.swift
//  Contact
//
//  Created by Andrew O'Brien on 12/25/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation
import UIKit

class SexOnboardingViewController: OnboardingViewController {
    
    var selectedSex: Sex = .unknown
    
    lazy var maleIcon: man = {
        let manIcon = man(frame: CGRect(x: 0, y: 0, width: 160, height: 280))
        manIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectSex(_:))))
        return manIcon
    }()
    
    lazy var femaleIcon: woman = {
        let womanIcon = woman(frame: CGRect(x: 0, y: 0, width: 160, height: 280))
        womanIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectSex(_:))))
        return womanIcon
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.isActive = true
        setupView()
    }
    
    func setupView() {
        inputContainer.addSubview(maleIcon)
        inputContainer.addSubview(femaleIcon)
        
        maleIcon.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(280)
            make.width.equalTo(160)
        }
        
        femaleIcon.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(280)
            make.width.equalTo(160)
        }
        
        inputContainer.resizeToFitSubviews()
    }
    
    @objc
    func didSelectSex(_ sender: UITapGestureRecognizer) {
        if let manIcon = sender.view as? man {
            self.selectedSex = .male
            manIcon.isSelected = true
            self.femaleIcon.isSelected = false
        }
        
        if let womanIcon = sender.view as? woman {
            self.selectedSex = .female
            womanIcon.isSelected = true
            self.maleIcon.isSelected = false
        }
    }
}
