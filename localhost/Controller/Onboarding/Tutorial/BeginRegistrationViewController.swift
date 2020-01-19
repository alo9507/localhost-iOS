//
//  BeginRegistration.swift
//  Contact
//
//  Created by Andrew O'Brien on 12/14/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//
import UIKit

class BeginRegistrationViewController: OnboardingViewController {
    
    lazy var mainLabel: UILabel = {
        let mainLabel = UILabel()
        mainLabel.text = """
        good answer!
        
        let's get you in the network
        """
        mainLabel.sizeToFit()
        mainLabel.numberOfLines = 0
        mainLabel.textAlignment = .center
        mainLabel.font = Fonts.avenirNext_bold(32)
        mainLabel.textColor = UIColor.lhPink
        
        return mainLabel
    }()
    
    lazy var joinLocalhost: UIButton = {
        let joinLocalhost = UIButton(frame: CGRect(x: 100, y: 100, width: 400, height: 50))
        
        let attributedTitle = NSAttributedString(string: "join localhost", attributes: [
            NSAttributedString.Key.foregroundColor : UIColor.lhPink,
            NSAttributedString.Key.font: Fonts.avenirNext_bold(28)
        ])
        
        joinLocalhost.setAttributedTitle(attributedTitle, for: .normal)
        joinLocalhost.layer.cornerRadius = 30
        joinLocalhost.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        joinLocalhost.backgroundColor = UIColor.lhTurquoise
        
        joinLocalhost.addTarget(self, action: #selector(beginRegistration), for: .touchUpInside)
        
        return joinLocalhost
    }()
    
    var showUnintrigued: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.lhPurple
        render()
    }
    
}

extension BeginRegistrationViewController {
    private func render() {
        constructHierarchy()
        activateConstraints()
    }
    
    func constructHierarchy() {
        inputContainer.addSubview(mainLabel)
        inputContainer.addSubview(joinLocalhost)
        inputContainer.resizeToFitSubviews(300)
    }
    
    func activateConstraints() {
        mainLabel.snp.makeConstraints { (make) in
            make.width.equalTo(view.bounds.width/1.8)
            make.top.equalToSuperview().offset(50)
            make.centerX.equalToSuperview()
        }
        
        joinLocalhost.snp.makeConstraints { (make) in
            make.top.equalTo(mainLabel.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(25)
            make.height.equalTo(60)
        }
    }
}

extension BeginRegistrationViewController {
    @objc
    func beginRegistration() {
        let regCoordinator = RegistrationCoordinator(presenter: self, userRepository: AppDelegate.appContainer.userRepository, userSessionRepository: AppDelegate.appContainer.userSessionRepository)
        regCoordinator.start()
    }
}
