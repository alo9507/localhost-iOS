//
//  ChangeProfileViewModel.swift
//  Contact
//
//  Created by Andrew O'Brien on 1/11/20.
//  Copyright © 2020 Andrew O'Brien. All rights reserved.
//

import Foundation
import UIKit

protocol ChangeProfileViewModelDelegate: class {
    func userSession(_ userSession: UserSession)
    func dismissSelf() -> Void
}

class ChangeProfileViewModel {
    let editedUser: User = UserSessionStore.user.copy()
    
    let userSessionRepository: UserSessionRepository
    let userRepository: UserRepository
    
    weak var delegate: ChangeProfileViewModelDelegate?
    
    init(userSessionRepository: UserSessionRepository, userRepository: UserRepository) {
        self.userSessionRepository = userSessionRepository
        self.userRepository = userRepository
    }
    
    @objc
    func cancel() {
        delegate?.dismissSelf()
    }
    
    @objc
    func updateUserProfile() {
        delegate?.dismissSelf()
        
        userSessionRepository.updateUserSession(data: editedUser.documentData) { (userSession, error) in
            if error != nil { return print(error!.localizedDescription) }
            guard let userSession = userSession else { return print(LHError.illegalState("Nil User : Nil Error")) }
            print(userSession)
        }
    }
    
}
