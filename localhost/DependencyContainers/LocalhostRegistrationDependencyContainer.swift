//
//  LocalhostRegistrationDependencyContainer.swift
//  Contact
//
//  Created by Andrew O'Brien on 8/18/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation
import UIKit

class LocalhostRegistrationDependencyContainer {
    
    public let usersRepository: UserRepository
    public let userSessionRepository: UserSessionRepository
    
    init(appDependencyContainer: LocalhostAppDependencyContainer) {
        self.usersRepository = appDependencyContainer.userRepository
        self.userSessionRepository = appDependencyContainer.userSessionRepository
    }
    
    func makeRegistrationPageViewController() -> OnboardingPageViewController {
        return OnboardingPageViewController()
    }
}
