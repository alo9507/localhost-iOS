//
//  MainCoordinator.swift
//  Contact
//
//  Created by Andrew O'Brien on 11/27/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import UIKit

class ApplicationCoordinator: Coordinator {
    
    let window: UIWindow
    
    weak var mainViewController: MainViewController? = AppDelegate.appContainer.makeMainViewController()
    var mainTabBarController: MainTabBarController?
    var tabBarCoordinator: TabBarCoordinator?
    
    init(window: UIWindow) {
        self.window = window
        super.init()
    }
    
    func start(with option: DeepLinkOption?) {
        if let option = option {
            switch option {
            case .profileDetail:
                tabBarCoordinator?.start(with: option)
            case .chat:
                tabBarCoordinator?.start(with: option)
            }
        }
    }
    
    override func start() {
        mainViewController?.viewModel.presentFirstLaunch = {
            self.presentFirstLaunchTutorial()
        }
        
        mainViewController?.viewModel.presentAuthentication = {
            self.presentAuthentication()
        }
        
        mainViewController?.viewModel.presentMainTabBarController = { (userSession) in
            self.presentMainTabBarController(userSession: userSession!)
        }
        
        window.rootViewController = mainViewController
        window.makeKeyAndVisible()
    }
    
    public func presentAuthentication() {
        let authCoordinator = AppDelegate.appContainer.makeAuthenticationCoordinator(presenter: mainViewController!)
        authCoordinator.start()
    }
    
    public func presentFirstLaunchTutorial() {
        let onboardingTutorialCoordinator = AppDelegate.appContainer.makeTutorialCoordinator(presenter: mainViewController!)
        onboardingTutorialCoordinator.start()
    }
    
    public func presentRegistration() {
        let registrationCoordinator = AppDelegate.appContainer.makeRegistrationCoordinator(presenter: mainViewController!)
        registrationCoordinator.start()
    }
    
    public func presentMainTabBarController(with option: DeepLinkOption?) {
        tabBarCoordinator!.start(with: option)
    }
    
    public func presentMainTabBarController(userSession: UserSession) {
        let tabBarCoordinator = AppDelegate.appContainer.makeMainTabBarCoordinator(presenter: mainViewController!, userSession: userSession)
        self.tabBarCoordinator = tabBarCoordinator
        tabBarCoordinator.start()
    }
    
}
