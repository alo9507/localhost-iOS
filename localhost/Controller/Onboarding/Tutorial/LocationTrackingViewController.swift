//
//  LocationTrackingViewController.swift
//  Contact
//
//  Created by Andrew O'Brien on 12/14/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import UIKit
import SnapKit

class LocationTrackingViewController: DismissableViewController {
    lazy var mainLabel: UILabel = {
        let mainLabel = UILabel()
        mainLabel.text = self.screenText
        mainLabel.numberOfLines = 0
        mainLabel.sizeToFit()
        mainLabel.textAlignment = .center
        mainLabel.textColor = .white
        mainLabel.font = Fonts.avenirNext_bold(20)
        return mainLabel
    }()
    
    var showRegistration: (() -> Void)?
    
    var screenText: String
    
    init(_ screenText: String) {
        self.screenText = screenText
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.lhPurple
        render()
    }
    
}

extension LocationTrackingViewController {
    private func render() {
        constructHierarchy()
        activateConstraints()
    }
    
    func constructHierarchy() {
        view.addSubview(mainLabel)
    }
    
    func activateConstraints() {
        
        mainLabel.snp.makeConstraints { (make) in
            make.width.equalToSuperview().inset(25)
            make.center.equalToSuperview()
        }
    }
}
