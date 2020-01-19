//
//  LocationAccess.swift
//  Contact
//
//  Created by Andrew O'Brien on 12/27/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import Lottie

class LocationAccess: OnboardingViewController {
    var location: String = ""
    var isHometown: Bool = false
    
    let animationView: AnimationView = {
        let animationView = AnimationView()
        let animation = Animation.named("big_globe_anim")
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.backgroundBehavior = .pauseAndRestore
        return animationView
    }()
    
    lazy var allowLocation: UIViewController = {
        let allowLocation = PaddingLabelSwiftUI.vc("enable location")
        let tapGesture = UITapGestureRecognizer(target: viewModel, action: #selector(LocationAccessViewModel.requestLocationAccess))
        tapGesture.numberOfTapsRequired = 1
        allowLocation.view.addGestureRecognizer(tapGesture)
        return allowLocation
    }()
    
    lazy var yourLocationLabel: UILabel = {
        let yourLocationLabel = UILabel()
        yourLocationLabel.text = ""
        yourLocationLabel.alpha = 0
        yourLocationLabel.font = Fonts.avenirNext_demibold(24)
        yourLocationLabel.textColor = UIColor.lhPink
        yourLocationLabel.textAlignment = .center
        yourLocationLabel.numberOfLines = 0
        yourLocationLabel.sizeToFit()
        return yourLocationLabel
    }()
    
    let yesButton: SaveButton = {
        let yesButton = SaveButton("yes")
        yesButton.addTarget(self, action: #selector(yesTapped), for: .touchUpInside)
        yesButton.alpha = 0
        return yesButton
    }()
    
    let noButton: SaveButton = {
        let noButton = SaveButton("no")
        noButton.addTarget(self, action: #selector(noTapped), for: .touchUpInside)
        noButton.alpha = 0
        return noButton
    }()
    
    let viewModel: LocationAccessViewModel
    
    init(viewModel: LocationAccessViewModel) {
        self.viewModel = viewModel
        super.init(title: "wya?", subtitle: "localhost revolves around your location", showProgressLabel: true, showNextButton: false, showBackButton: true)
        viewModel.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        render()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animationView.play(fromProgress: 0,
                           toProgress: 1,
                           loopMode: LottieLoopMode.repeatBackwards(100),
                           completion: { (finished) in
                            if finished {
                              print("Animation Complete")
                            } else {
                              print("Animation cancelled")
                            }
        })
    }
}

extension LocationAccess {
    private func render() {
        constructHierarchy()
        activateConstraints()
    }
    
    func constructHierarchy() {
        inputContainer.addSubview(animationView)
        view.addSubview(allowLocation.view)
        view.addSubview(yourLocationLabel)
        view.addSubview(yesButton)
        view.addSubview(noButton)
    }
    
    func activateConstraints() {
        animationView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.center.equalToSuperview()
            make.width.equalToSuperview().inset(30)
            make.height.equalTo(400)
        }
        
        allowLocation.view.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(100)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(25)
        }
        
        yourLocationLabel.snp.makeConstraints { (make) in
            make.top.equalTo(animationView.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(25)
        }
        
        noButton.snp.makeConstraints { (make) in
            make.top.equalTo(yourLocationLabel.snp.bottom).offset(5)
            make.width.equalToSuperview().dividedBy(2.5)
            make.left.equalToSuperview().offset(10)
        }
        
        yesButton.snp.makeConstraints { (make) in
            make.top.equalTo(yourLocationLabel.snp.bottom).offset(5)
            make.width.equalToSuperview().dividedBy(2.5)
            make.right.equalToSuperview().offset(-10)
        }
    }
}

extension LocationAccess: LocationAccessViewModelDelegate {
    func locationDetected(_ location: String) {
        self.location = location
        yourLocationLabel.text  = "We see you're in \(location)! Is this where you live?"
        UIView.animate(withDuration: 0.24) {
            self.allowLocation.view.alpha = 0
            self.yourLocationLabel.alpha = 1
            self.yesButton.alpha = 1
            self.noButton.alpha = 1
        }
    }
}

extension LocationAccess {
    @objc
    func yesTapped() {
        isHometown = true
        self.nextButtonPressed(UIButton())
    }
    
    @objc
    func noTapped() {
        self.nextButtonPressed(UIButton())
    }
}
