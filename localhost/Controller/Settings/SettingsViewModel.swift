//
//  SettingsViewModel.swift
//  Contact
//
//  Created by Andrew O'Brien on 8/15/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation

class SettingsViewModel {
    
    let userSessionRepository: UserSessionRepository
    
    var showPreferences: (() -> Void)?
    var showAccount: (() -> Void)?
    var showEditProfile: (() -> Void)?
    
    init(
        userSessionRepository: UserSessionRepository
    ) {
        self.userSessionRepository = userSessionRepository
    }
}
