//
//  TutorialCoordinator.swift
//  Contact
//
//  Created by Andrew O'Brien on 12/14/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation
import UIKit

class TutorialCoordinator: Coordinator {
    private let presenter: UIViewController
    
    var onboardingPVC: OnboardingPageViewController?
    
    init(presenter: UIViewController) {
        self.presenter = presenter
    }
    
    override func start() {
        let vc1 = NewUserEducationFirstViewController(showProgressLabel: false, showNextButton: false, showBackButton: false)
        let vc2 = NewUserEducationSecondViewController(showProgressLabel: false, showNextButton: false, showBackButton: false)
        let vc3 = NewUserEducationThirdViewController(showProgressLabel: false, showNextButton: false, showBackButton: false)
        let vc4 = StartHostingViewController(showProgressLabel: false, showNextButton: false, showBackButton: false)
        let vc5 = BeginRegistrationViewController(showProgressLabel: false, showNextButton: false, showBackButton: false)
        
        vc3.showRegistration = {
            self.showRegistration()
        }
        
        vc4.showUnintrigued = {
            self.showUnintrigued()
        }
        
        let viewControllers = [vc1, vc2, vc3, vc4, vc5]
        
        let onboardingPVC = OnboardingPageViewController(orderedViewControllers: viewControllers, swipable: true)
        
        viewControllers.forEach { (vc) in
            vc.onboardingPageViewController = onboardingPVC
        }
        
        onboardingPVC.modalPresentationStyle = .fullScreen
        self.onboardingPVC = onboardingPVC
        presenter.present(onboardingPVC, animated: true, completion: nil)
    }
    
    private func showRegistration() {
        let registrationCoordinator = AppDelegate.appContainer.makeRegistrationCoordinator(presenter: onboardingPVC!)
        registrationCoordinator.start()
    }
    private func showUnintrigued() {
        onboardingPVC?.present(UnintriguedViewController(), animated: true, completion: nil)
    }
}
