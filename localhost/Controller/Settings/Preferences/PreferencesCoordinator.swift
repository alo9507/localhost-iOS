//
//  Preferences.swift
//  Contact
//
//  Created by Andrew O'Brien on 1/11/20.
//  Copyright © 2020 Andrew O'Brien. All rights reserved.
//

import Foundation
import UIKit

class PreferencesCoordinator: Coordinator {
    
    private let presenter: UIViewController
    var preferencesViewController: PreferencesViewController = AppDelegate.appContainer.makePreferencesViewController()
    
    init(presenter: UIViewController) {
        self.presenter = presenter
    }
    
    override func start() {
        preferencesViewController.viewModel.showShowMy = {
            self.showShowMy()
        }
        
        preferencesViewController.viewModel.showVisibilitySettings = {
            self.showVisibilitySettings()
        }
        
        preferencesViewController.modalPresentationStyle = .fullScreen
        presenter.present(self.preferencesViewController, animated: true, completion: nil)
    }
    
    func showShowMy() {
        let vc = AppDelegate.appContainer.makeShowMyVC()
        preferencesViewController.present(vc, animated: true, completion: nil)
    }
    
    func showVisibilitySettings() {
        let visibilitySettingsVC = AppDelegate.appContainer.makeVisibilitySettingsViewController()
        
        let visibilitySettingsWithNavBar: UINavigationController = UINavigationController(rootViewController: visibilitySettingsVC)
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
        
        preferencesViewController.present(visibilitySettingsWithNavBar, animated: true, completion: nil)
    }
}

