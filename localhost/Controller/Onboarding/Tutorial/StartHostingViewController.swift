//
//  StartHosting.swift
//  Contact
//
//  Created by Andrew O'Brien on 12/14/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import UIKit

class StartHostingViewController: OnboardingViewController {
    
    lazy var mainLabel: UILabel = {
        let mainLabel = UILabel()
        mainLabel.text = "start hosting?"
        mainLabel.numberOfLines = 3
        mainLabel.textAlignment = .center
        mainLabel.font = Fonts.avenirNext_bold(32)
        mainLabel.textColor = UIColor.lhPink
        
        return mainLabel
    }()
    
    lazy var imIntrigued: UIButton = {
        let imIntrigued = UIButton(frame: CGRect(x: 100, y: 100, width: 400, height: 50))
        
        let attributedTitle = NSAttributedString(string: "i'm intrigued", attributes: [
            NSAttributedString.Key.foregroundColor : UIColor.lhPink,
            NSAttributedString.Key.font: Fonts.avenirNext_bold(28)
        ])
        
        imIntrigued.setAttributedTitle(attributedTitle, for: .normal)
        imIntrigued.layer.cornerRadius = 30
        imIntrigued.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        imIntrigued.backgroundColor = UIColor.lhTurquoise
        
        imIntrigued.addTarget(self, action: #selector(imIntriguedTapped), for: .touchUpInside)
        return imIntrigued
    }()
    
    lazy var imUnintrigued: UIButton = {
        let imUnintrigued = UIButton(frame: CGRect(x: 100, y: 100, width: 400, height: 50))
        
        let attributedTitle = NSAttributedString(string: "i'm unintrigued", attributes: [
            NSAttributedString.Key.foregroundColor : UIColor.lhPink,
            NSAttributedString.Key.font: Fonts.avenirNext_bold(28)
        ])
        
        imUnintrigued.setAttributedTitle(attributedTitle, for: .normal)
        
        imUnintrigued.layer.cornerRadius = 30
        imUnintrigued.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        imUnintrigued.backgroundColor = UIColor.lhTurquoise
        
        imUnintrigued.addTarget(self, action: #selector(imUnintriguedTapped), for: .touchUpInside)
        return imUnintrigued
    }()
    
    var showUnintrigued: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.lhPurple
        render()
    }
    
}

extension StartHostingViewController {
    private func render() {
        constructHierarchy()
        activateConstraints()
    }
    
    func constructHierarchy() {
        inputContainer.addSubview(mainLabel)
        inputContainer.addSubview(imIntrigued)
        inputContainer.addSubview(imUnintrigued)
        inputContainer.resizeToFitSubviews(300)
    }
    
    func activateConstraints() {
        mainLabel.snp.makeConstraints { (make) in
            make.width.equalTo(view.bounds.width/1.8)
            make.top.equalToSuperview().offset(50)
            make.centerX.equalToSuperview()
        }
        
        imIntrigued.snp.makeConstraints { (make) in
            make.top.equalTo(mainLabel.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(25)
            make.height.equalTo(60)
        }
        
        imUnintrigued.snp.makeConstraints { (make) in
            make.top.equalTo(imIntrigued.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(25)
            make.height.equalTo(60)
        }
    }
}

extension StartHostingViewController {
    @objc
    func imUnintriguedTapped() {
        self.showUnintrigued?()
    }
    
    @objc
    func imIntriguedTapped() {
        self.delegate?.onboardingViewController(self, nextButtonPressed: true)
    }
}
