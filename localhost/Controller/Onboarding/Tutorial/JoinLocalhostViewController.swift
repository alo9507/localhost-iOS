//
//  JoinLocalhost.swift
//  Contact
//
//  Created by Andrew O'Brien on 12/14/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import UIKit
import SnapKit

class JoinLocalhostViewController: OnboardingViewController {
    
    lazy var mainLabel: UILabel = {
        let mainLabel = UILabel()
        mainLabel.text = "join localhost!"
        mainLabel.numberOfLines = 2
        mainLabel.textAlignment = .center
        mainLabel.textColor = .white
        mainLabel.font = Fonts.avenirNext_bold(20)
        return mainLabel
    }()
    
    var showRegistration: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.lhPurple
        render()
    }
    
}

extension JoinLocalhostViewController {
    private func render() {
        constructHierarchy()
        activateConstraints()
    }
    
    func constructHierarchy() {
        inputContainer.addSubview(mainLabel)
        inputContainer.resizeToFitSubviews()
    }
    
    func activateConstraints() {
        mainLabel.snp.makeConstraints { (make) in
            make.width.equalTo(view.bounds.width/1.8)
            make.center.equalToSuperview()
        }
    }
}
