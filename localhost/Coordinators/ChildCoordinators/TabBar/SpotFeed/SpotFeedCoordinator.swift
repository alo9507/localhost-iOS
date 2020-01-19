//
//  SpotFeedCoordinator.swift
//  Contact
//
//  Created by Andrew O'Brien on 11/29/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation
import UIKit

class SpotFeedCoordinator: Coordinator {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() {
        let spotFeedViewController = self.navigationController.viewControllers[0] as! SpotFeedViewController
        
        spotFeedViewController.viewModel.showEditStatus = {
            self.showEditStatus()
        }
        
        spotFeedViewController.viewModel.showProfileDetail = { (featuredUser, origin) in
            self.showProfileDetail(featuredUser: featuredUser, origin: origin)
        }
        
        spotFeedViewController.viewModel.showVisibilitySettings = {
            self.showVisibilitySettings()
        }
    }
    
    func showEditStatus() {
        let editStatusModal = AppDelegate.appContainer.makeEditStatusViewController()
        
        editStatusModal.submissionSuccessful = {
            editStatusModal.dismiss(animated: true, completion: nil)
        }
        
        navigationController.present(editStatusModal, animated: true, completion: nil)
    }
    
    func showProfileDetail(featuredUser: User, origin: Origin) {
        let profileDetailCoordinator = AppDelegate.appContainer.makeProfileDetailCoordinator(navigationController,featuredUser, origin)
        profileDetailCoordinator.start()
    }
    
    func showShowMy() {
        let showMyVC = AppDelegate.appContainer.makeShowMyVC()
        navigationController.present(showMyVC, animated: true, completion: nil)
    }
    
    func showVisibilitySettings() {
        let visibilitySettingsViewController = AppDelegate.appContainer.makeVisibilitySettingsViewController()
        
        let visibilitySettingsWithNavBar: UINavigationController = UINavigationController(rootViewController: visibilitySettingsViewController)
        visibilitySettingsWithNavBar.modalPresentationStyle = .fullScreen
        
        if #available(iOS 13.0, *) {
            let standard = UINavigationBarAppearance()
            standard.configureWithOpaqueBackground()
            standard.backgroundColor = UIColor.init(hexString: "#9917C4", withAlpha: 0.25)
            standard.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor.white,
                NSAttributedString.Key.font: UIFont(name: "AvenirNext-Bold", size: 22.0)!
            ]
            visibilitySettingsWithNavBar.navigationBar.standardAppearance = standard
        } else {
            UINavigationBar.appearance().titleTextAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor.white
            ]
            UINavigationBar.appearance().barTintColor = UIColor.init(hexString: "#9917C4", withAlpha: 0.25)
        }
        
        navigationController.present(visibilitySettingsWithNavBar, animated: true, completion: nil)
    }
    
}
