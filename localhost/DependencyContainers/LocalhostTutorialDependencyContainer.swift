//
//  LocalhostTutorialDependencyFactory.swift
//  Contact
//
//  Created by Andrew O'Brien on 8/18/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation
import UIKit

class LocalhostTutorialDependencyContainer {
    func makeNewUserEducationPageViewController() -> OnboardingPageViewController {
        let viewControllers = [
            makeNewUserEducationFirstViewController(), makeNewUserEducationSecondViewController(), makeNewUserEducationThirdViewController()]
        return OnboardingPageViewController(orderedViewControllers: viewControllers, swipable: true)
    }
    
    func makeNewUserEducationFirstViewController() -> NewUserEducationFirstViewController {
        return NewUserEducationFirstViewController()
    }
    
    func makeNewUserEducationSecondViewController() -> NewUserEducationSecondViewController {
        return NewUserEducationSecondViewController()
    }
    
    func makeNewUserEducationThirdViewController() -> NewUserEducationThirdViewController {
        return NewUserEducationThirdViewController()
    }
}
