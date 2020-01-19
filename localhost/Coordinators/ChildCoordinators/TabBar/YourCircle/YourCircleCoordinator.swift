//
//  YourCircleCoordinator.swift
//  Contact
//
//  Created by Andrew O'Brien on 12/3/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation
import UIKit

class YourCircleCoordinator: Coordinator {

    private let navigationController: UINavigationController
    private let yourCircleViewController: YourCircleViewController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.yourCircleViewController = navigationController.viewControllers[0] as! YourCircleViewController
        
        super.init()
        
        childCoordinators.append(AppDelegate.appContainer.makeMatchesCoordinator())
        childCoordinators.append(AppDelegate.appContainer.makeChatRoomsCoordinator())
    }

    override func start() {
        childCoordinators.forEach { (childCoordinator) in
            childCoordinator.start()
        }
    }
}
