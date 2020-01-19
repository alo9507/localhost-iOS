//
//  AccountViewModel.swift
//  Contact
//
//  Created by Andrew O'Brien on 1/10/20.
//  Copyright © 2020 Andrew O'Brien. All rights reserved.
//

import Foundation

protocol AccountViewModelDelegate {
    func logoutSuccessful()
    func errorLoggingOut(error: Error)
    func credentialsRequiredToDeleteAccount()
    func deleteAccountSuccessful()
}

class AccountViewModel {
    
    let userSessionRepository: UserSessionRepository
    let userRepository: UserRepository
    
    var delegate: AccountViewModelDelegate?
    
    var verifyUserWantsToLogout: (() -> Void)?
    var verifyUserWantsToDeleteAccount: (() -> Void)?
    var showAuthenticationScreen: (() -> Void)?
    var showPromptForCredentials: (() -> Void)?
    
    init(
        userSessionRepository: UserSessionRepository,
        userRepository: UserRepository
    ) {
        self.userSessionRepository = userSessionRepository
        self.userRepository = userRepository
    }
    
    func signOut() {
        userSessionRepository.signOut() { (error) in
            if error != nil { return (self.delegate?.errorLoggingOut(error: error!))! }
            self.delegate?.logoutSuccessful()
        }
    }
    
    func deleteAccount() {
        userRepository.deleteUser(user: UserSessionStore.user) { (error) in
            if error != nil {
                switch error {
                case .credentialsRequiredToDeleteAccount( _):
                    self.delegate?.credentialsRequiredToDeleteAccount()
                    return
                case .failedToDeleteAccount(let error):
                    fatalError(error)
                default:
                    fatalError()
                }
            }
            self.delegate?.deleteAccountSuccessful()
        }
    }
    
    func signInToDeleteAccount(email: String, password: String) {
        userSessionRepository.signIn(email: email, password: password) { (userSession, error) in
            if error != nil { return print(error!.localizedDescription) }
            guard let userSession = userSession else {
                print(LHError.illegalState("Nil User : Nil Error").localizedDescription)
                return
            }
            self.deleteAccount()
        }
    }
}
