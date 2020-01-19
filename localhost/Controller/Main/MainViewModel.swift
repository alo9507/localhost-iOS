//
//  MainViewModel.swift
//  Contact
//
//  Created by Andrew O'Brien on 8/20/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation

public class MainViewModel {
    var presentLaunching: (() -> Void)?
    var presentAuthentication: (() -> Void)?
    var presentFirstLaunch: (() -> Void)?
    var presentMainTabBarController: ((UserSession?) -> Void)?
    
    private let firstLaunchService: FirstLaunch
    private let userSessionRepository: UserSessionRepository
    private let usersRepo: UserRepository
    
    init(
        firstLaunchService: FirstLaunch,
        userSessionRepository: UserSessionRepository,
        usersRepo: UserRepository
    ) {
        self.firstLaunchService = firstLaunchService
        self.userSessionRepository = userSessionRepository
        self.usersRepo = usersRepo
    }
    
    public func checkForFirstLaunch() {
        if firstLaunchService.isFirstLaunch {
            self.presentFirstLaunch?()
        }
    }
    
    public func loadUserSession() {
        userSessionRepository
            .readUserSession() { (userSession, error) in
                if error != nil { fatalError(error!.localizedDescription) }
                if userSession != nil {
                    self.presentMainTabBarController?(userSession)
                } else {
                    self.presentAuthentication?()
                }
        }
    }
}
