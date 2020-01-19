//
//  AuthenticationViewModel.swift
//  Contact
//
//  Created by Andrew O'Brien on 8/12/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

protocol AuthenticationViewControllerDelegate: class {
    func userSession(_ userSession: UserSession?)
    func clearFields(_ clearFields: Bool)
    func inputEnabled(_ inputEnabled: Bool)
    func signInActivityIndicatorAnimating(_ signInActivityIndicatorAnimating: Bool)
    func errorMessage(_ error: LHError)
    func endEditing(_ endEditing: Bool)
}

public class AuthenticationViewModel: UserSessionStoreSubscriber {
    func userSessionUpdated(_ userSession: UserSession) {
        self.delegate?.userSession(userSession)
    }
    
    var currentUser: User {
        return UserSessionStore.shared.userSession.user
    }
    
    var userSession: UserSession {
        return UserSessionStore.shared.userSession
    }
    
    let userRepo: UserRepository
    let userSessionRepository: UserSessionRepository
    
    var showMainTabBar: ((UserSession) -> Void)?
    var showRegistration: (() -> Void)?
    var showPasswordReset: (() -> Void)?
    
    public var emailInput = ""
    public var passwordInput = ""
    
    init(
        userSessionRepository: UserSessionRepository,
        userRepo: UserRepository
        ) {
        self.userSessionRepository = userSessionRepository
        self.userRepo = userRepo
        
        UserSessionStore.subscribe(self)
    }
    
    weak var delegate: AuthenticationViewControllerDelegate? {
        didSet {
            delegate?.userSession(UserSessionStore.shared.userSession)
        }
    }
    
}

extension AuthenticationViewModel { 
    @objc
    func registerButtonPressed(_ sender: Any) {
        self.showRegistration?()
    }
    
    @objc
    func hideKeyboard(_ sender: Any) {
        delegate?.endEditing(true)
    }
}

extension AuthenticationViewModel {
    func signIn(_ email: String, _ password: String) {
        userSessionRepository.signIn(email: email, password: password) { (userSession, error) in
            if error != nil {
                print(error!.localizedDescription)
                self.indicateErrorSigningIn(error!)
            }
            guard let userSession = userSession else { return print("No User Session?") }
            self.indicateAuthSuccessful()
            self.showMainTabBar?(userSession)
        }
    }
    
    @objc
    func forgotPassword() {
        self.showPasswordReset?()
    }
    
    func getEmailPassword() -> (String, String) {
        return (emailInput, passwordInput)
    }
    
    func indicateSigningIn() {
        self.delegate?.inputEnabled(false)
        self.delegate?.signInActivityIndicatorAnimating(true)
    }
    
    func indicateAuthSuccessful() {
        delegate?.clearFields(true)
        delegate?.signInActivityIndicatorAnimating(false)
        delegate?.inputEnabled(true)
        delegate?.clearFields(true)
    }
    
    func indicateErrorSigningIn(_ error: LHError) {
        delegate?.errorMessage(error)
        delegate?.inputEnabled(true)
        delegate?.signInActivityIndicatorAnimating(false)
    }
}
