//
//  TabBarCoordinator.swift
//  Contact
//
//  Created by Andrew O'Brien on 11/29/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation
import UIKit

class TabBarCoordinator: Coordinator {
    private let presenter: UIViewController
    private let userSession: UserSession
    
    var mainTabBar: MainTabBarController?
    
    init(presenter: UIViewController, userSession: UserSession) {
        self.presenter = presenter
        self.userSession = userSession
        super.init()
        
        childCoordinators.append(AppDelegate.appContainer.makeSpotFeedCoordinator())
        childCoordinators.append(AppDelegate.appContainer.makeSettingsCoordinator())
        childCoordinators.append(AppDelegate.appContainer.makeYourCircleCoordinator())
    }
    
    func start(with option: DeepLinkOption?) {
        if let option = option {
            switch option {
            case .profileDetail(let userId):
                let spotFeedNav = AppDelegate.appContainer.spotFeedNavigationController
                AppDelegate.appContainer.userRepository.getUser(uid: userId) { (user, error) in
                    if error != nil { return print(error!.localizedDescription) }
                    guard let user = user else { return print("NO USER") }
                    let profileDetailCoordinator = AppDelegate.appContainer.makeProfileDetailCoordinator(spotFeedNav!, user, .spotFeed)
                    profileDetailCoordinator.start()
                }
            case .chat(let userId):
                let spotFeedNav = AppDelegate.appContainer.spotFeedNavigationController
                let user = UserSessionStore.shared.userSession.user
                
                let id1 = userId
                let id2 = user.uid
                let channelId = id1 < id2 ? id1 + id2 : id2 + id1
            default:
                return
            }
        }
    }
    
    override func start() {
        childCoordinators.forEach { (childCoordinator) in
            childCoordinator.start()
        }
        
        let mainTabBarController = AppDelegate.appContainer.makeMainTabBarController()
        
        let newNodCount = userSession.user.inboundNotOutbound.count
        if newNodCount != 0 {
            mainTabBarController.yourCircleNavigationController.tabBarItem.badgeValue = "\(newNodCount)"
        }
        
        self.mainTabBar = mainTabBarController
        
        mainTabBarController.modalPresentationStyle = .fullScreen
        presenter.present(mainTabBarController, animated: true)
    }
}
