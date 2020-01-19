//
//  localhostFactory.swift
//  Contact
//
//  Created by Andrew O'Brien on 8/11/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation

class LocalhostAppDependencyContainer {
    func makeNewUserEducationPageViewController() -> NewUserEducationPageViewController {
        let viewControllers = [makeNewUserEducationFirstViewController(), makeNewUserEducationSecondViewController(), makeNewUserEducationThirdViewController()]
        return NewUserEducationPageViewController(viewControllerFlow: viewControllers)
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
    
    func makeAuthenticationViewController() -> AuthenticationViewController {
        return AuthenticationViewController()
    }
    
    func makeSpotFeedViewController() -> SpotFeedViewController {
        return SpotFeedViewController()
    }
    
    func makeSettingsViewController() -> SettingsViewController {
        return SettingsViewController()
    }
    
    func makeProfileDetailViewController(user: User) -> ProfileDetailViewController {
        return ProfileDetailViewController(user: user)
    }
}
