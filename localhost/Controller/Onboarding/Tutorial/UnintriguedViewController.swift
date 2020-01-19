//
//  UnintriguedViewController.swift
//  Contact
//
//  Created by Andrew O'Brien on 12/14/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import UIKit
import SwiftUI

class UnintriguedViewController: DismissableViewController {
    lazy var mainLabel: UILabel = {
        let mainLabel = UILabel()
        mainLabel.text = "why are you unintrigued?"
        mainLabel.numberOfLines = 0
        mainLabel.sizeToFit()
        mainLabel.textAlignment = .center
        mainLabel.font = Fonts.avenirNext_bold(32)
        mainLabel.textColor = UIColor.lhPink
        
        return mainLabel
    }()
    
    lazy var locationTracking: UIViewController = {
        let locationTracking = PaddingLabelSwiftUI.vc("I don't trust apps that track my location")
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showLocation))
        tapGesture.numberOfTapsRequired = 1
        locationTracking.view.addGestureRecognizer(tapGesture)
        return locationTracking
    }()
    
    lazy var strangerDanger: UIViewController = {
        let strangerDanger = PaddingLabelSwiftUI.vc("I'm worried about people seeing things about me in public")
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showStrangerDanger))
        tapGesture.numberOfTapsRequired = 1
        strangerDanger.view.addGestureRecognizer(tapGesture)
        return strangerDanger
    }()
    
    lazy var alreadyPopular: UIViewController = {
        let alreadyPopular = PaddingLabelSwiftUI.vc("i'm already incredibly popular and am friends, colleagues, related to, and/or the boss of everyone ever worth meeting in my town or city")
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showAlreadyPopular))
        tapGesture.numberOfTapsRequired = 1
        alreadyPopular.view.addGestureRecognizer(tapGesture)
        return alreadyPopular
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.lhPurple
        render()
    }
    
    override func viewWillDisappear(_ animated: Bool) {}
    override func viewWillAppear(_ animated: Bool) {}
}

extension UnintriguedViewController {
    private func render() {
        constructHierarchy()
        activateConstraints()
    }
    
    func constructHierarchy() {
        view.addSubview(mainLabel)
        view.addSubview(locationTracking.view)
        view.addSubview(strangerDanger.view)
        view.addSubview(alreadyPopular.view)
    }
    
    func activateConstraints() {
        downwardArrow.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(30)
        }
        
        mainLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(30)
            make.centerX.equalToSuperview()
            make.width.equalTo(view.bounds.width/1.8)
        }
        
        locationTracking.view.snp.makeConstraints { (make) in
            make.top.equalTo(mainLabel.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(25)
        }
        
        strangerDanger.view.snp.makeConstraints { (make) in
            make.top.equalTo(locationTracking.view.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(25)
        }
        
        alreadyPopular.view.snp.makeConstraints { (make) in
            make.top.equalTo(strangerDanger.view.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(25)
        }
    }
}

extension UnintriguedViewController {
    @objc
    func showLocation() {
        self.present(LocationTrackingViewController("explanation of how localhost uses location data"), animated: true, completion: nil)
    }
    
    @objc
    func showStrangerDanger() {
        self.present(LocationTrackingViewController("demo of fine-grained visibility controls"), animated: true, completion: nil)
    }
    
    @objc
    func showAlreadyPopular() {
        let msg =
        """
        you sound pretty awesome.
        join localhost!
        """
        self.present(LocationTrackingViewController(msg), animated: true, completion: nil)
    }
}

