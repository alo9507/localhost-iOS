//
//  MatchesCoordinator.swift
//  Contact
//
//  Created by Andrew O'Brien on 12/3/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation
import UIKit

class MatchesCoordinator: Coordinator {
    
    private let navigationController: UINavigationController
    private let matchesViewController: MatchesViewController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.matchesViewController = (navigationController.viewControllers[0] as! YourCircleViewController).matchesViewController
    }
    
    override func start() {
        matchesViewController.viewModel.showProfileDetail = { (featuredUser, origin) in
            self.showProfileDetail(featuredUser: featuredUser, origin: origin)
        }
    }
    
    func showProfileDetail(featuredUser: User, origin: Origin) {
        let profileDetailCoordinator = AppDelegate.appContainer.makeProfileDetailCoordinator(navigationController, featuredUser, origin)
        profileDetailCoordinator.start()
    }
}
