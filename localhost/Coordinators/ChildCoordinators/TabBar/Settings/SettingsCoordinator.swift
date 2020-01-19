//
//  SettingsCoordinator.swift
//  Contact
//
//  Created by Andrew O'Brien on 12/3/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation
import UIKit

class SettingsCoordinator: Coordinator {
    
    private let navigationController: UINavigationController
    private let settingsViewController: SettingsViewController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.settingsViewController = navigationController.viewControllers[0] as! SettingsViewController
    }
    
    override func start() {
        settingsViewController.viewModel.showPreferences = {
            self.showPreferences()
        }
        
        settingsViewController.viewModel.showAccount = {
            self.showAccount()
        }
        
        settingsViewController.viewModel.showEditProfile = {
            self.showEditProfile()
        }
    }
    
    func showPreferences() {
        let preferencesCoordinator = AppDelegate.appContainer.makePreferencesCoordinator(presenter: navigationController)
        preferencesCoordinator.start()
    }
    
    func showAccount() {
        let accountCoordinator = AppDelegate.appContainer.makeAccountCoordinator(presenter: navigationController)
        accountCoordinator.start()
    }
    
    func showEditProfile() {
        let changeProfileVC = AppDelegate.appContainer.makeChangeProfileViewController(UserSessionStore.user)
        
        let changeProfileVCWithNavBar: UINavigationController = UINavigationController(rootViewController: changeProfileVC)
        changeProfileVCWithNavBar.modalPresentationStyle = .fullScreen
        
        if #available(iOS 13.0, *) {
            let standard = UINavigationBarAppearance()
            standard.configureWithOpaqueBackground()
            standard.backgroundColor = UIColor.init(hexString: "#9917C4", withAlpha: 0.25)
            standard.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor.white,
                NSAttributedString.Key.font: UIFont(name: "AvenirNext-Bold", size: 22.0)!
            ]
            changeProfileVCWithNavBar.navigationBar.standardAppearance = standard
        } else {
            UINavigationBar.appearance().titleTextAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor.white
            ]
            UINavigationBar.appearance().barTintColor = UIColor.init(hexString: "#9917C4", withAlpha: 0.25)
        }
        
        changeProfileVCWithNavBar.modalPresentationStyle = .fullScreen
        
        navigationController.present(changeProfileVCWithNavBar, animated: true, completion: nil)
    }
    
}
