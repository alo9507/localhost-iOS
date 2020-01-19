//
//  AuthenticationCoordinator.swift
//  Contact
//
//  Created by Andrew O'Brien on 12/3/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation
import UIKit

class AuthenticationCoordinator: Coordinator {

    private let authenticationViewController: AuthenticationViewController = {
        let authenticationViewController = AppDelegate.appContainer.makeAuthenticationViewController()
        authenticationViewController.modalPresentationStyle = .fullScreen
        return authenticationViewController
    }()

    private lazy var mainTabBarController: MainTabBarController = {
        let mainTabBarController = AppDelegate.appContainer.makeMainTabBarController()
        mainTabBarController.modalPresentationStyle = .fullScreen
        return mainTabBarController
    }()
    
    private let presenter: UIViewController
    
    init(presenter: UIViewController) {
        self.presenter = presenter
    }

    override func start() {
        authenticationViewController.viewModel.showMainTabBar = { userSession in
            self.presentMainTabBarController(userSession)
        }
        
        authenticationViewController.viewModel.showRegistration = {
            self.showRegistration()
        }
        
        authenticationViewController.viewModel.showPasswordReset = {
            self.showPasswordReset()
        }
        
        presenter.present(authenticationViewController, animated: true, completion: nil)
    }
    
    public func presentMainTabBarController(_ userSession: UserSession?) {
        let tabBarCoordinator = AppDelegate.appContainer.makeMainTabBarCoordinator(presenter: authenticationViewController, userSession: userSession!)
        tabBarCoordinator.start()
    }
    
    func showRegistration() {
        let registrationCoordinator = AppDelegate.appContainer.makeRegistrationCoordinator(presenter: authenticationViewController)
        registrationCoordinator.start()
    }
    
    func showPasswordReset() {
        let resetEmailVC = AppDelegate.appContainer.makeResetEmailVC()
        authenticationViewController.present(resetEmailVC, animated: true, completion: nil)
    }
}
