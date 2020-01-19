//
//  PreferencesViewModel.swift
//  Contact
//
//  Created by Andrew O'Brien on 1/10/20.
//  Copyright © 2020 Andrew O'Brien. All rights reserved.
//

import Foundation

protocol PreferencesViewModelDelegate {
    func logoutSuccessful()
    func errorLoggingOut(error: Error)
}

class PreferencesViewModel {
    
    let userSessionRepository: UserSessionRepository
    
    var delegate: PreferencesViewModelDelegate?
    
    var showVisibilitySettings: (() -> Void)?
    var showShowMy: (() -> Void)?
    
    init(
        userSessionRepository: UserSessionRepository
    ) {
        self.userSessionRepository = userSessionRepository
    }
    
    func signOut() {
        userSessionRepository.signOut() { (error) in
            if error != nil { return (self.delegate?.errorLoggingOut(error: error!))! }
            self.delegate?.logoutSuccessful()
        }
    }
}
