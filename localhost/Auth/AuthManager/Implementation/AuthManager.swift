//
//  AuthManager.swift
//  AuthFramework
//
//  Created by Andrew O'Brien on 12/11/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation

class AuthManager: LHAuthManager {
    var authProvider: LHAuthProvider?
    
    var dataStore: LHAuthDataStore
    
    var authSession: LHAuthSession?
    
    lazy var remoteAuthProvider: RemoteAuthProvider = {
        guard let authProviderChoice = authProvider else {
            fatalError("""
            
            You must call Auth.configure(for: AuthProvider) before calling any methods on AuthFramework.
                You can initialize with the following AuthProviders: Firebase
                
                For testing, you can configure with .mock(mockRemoteAuthProvider: RemoteAuthProvider)
            """
            )
        }
        return authProviderChoice.remoteProvider
    }()
    
    init(
        authProvider: LHAuthProvider?,
        dataStore: LHAuthDataStore
    ) {
        self.authProvider = authProvider
        self.dataStore = dataStore
    }
    
    convenience init() {
        self.init(authProvider: nil,
                  dataStore: KeychainDataStore()
        )
    }
    
}

extension AuthManager {
    func signIn(email: String? = nil, password: String? = nil, phoneNumber: String? = nil, _ completion: @escaping LHAuthResponse) {
        remoteAuthProvider.signIn(email: email, password: password, phoneNumber: phoneNumber) { [weak self] (authSession, error) in
            guard error == nil else {
                return completion(nil, LHAuthError.failedToSignInWithRemote("email: \(email), password: \(password) \(error!.localizedDescription)"))
            }
            
            guard let authSession = authSession else {
                return completion(nil, LHAuthError.failedToRetrieveAuthSession("No AuthSession, but also no errors?"))
            }
            
            self?.dataStore.save(authSession: authSession, { (error) in
                guard error == nil else {
                    return completion(nil, LHAuthError.failedToPersistUserSessionData(error!.localizedDescription))
                }
                self!.authSession = authSession
                completion(authSession, nil)
            })
        }
    }
    
    func configure(for authProvider: LHAuthProvider, with dataStore: LHAuthDataStore? = nil) {
        self.authProvider = authProvider
        guard let dataStore = dataStore else { return }
        self.dataStore = dataStore
    }
    
    func clear(_ completion: @escaping LHAuthErrorResponse) {
        self.dataStore.delete { (error) in
            guard error == nil else {
                return completion(LHAuthError.failedToRemoveUserSessionData("Could not clear cached session: \(error!.localizedDescription)"))
            }
            completion(nil)
        }
    }
    
    func signUp(email: String, password: String,  _ completion: @escaping LHAuthResponse) {
        remoteAuthProvider.signUp(email: email, password: password) { (authSession, error) in
            if error != nil { return print(error!.localizedDescription) }
            guard let authSession = authSession else { return completion(nil, LHAuthError.failedToSignUpNewUser("No Auth session returned")) }
            
            self.dataStore.save(authSession: authSession) { (error) in
                if error != nil { return completion(nil, LHAuthError.failedToPersistUserSessionData(error!.localizedDescription)) }
                completion(authSession, nil)
            }
        }
    }
    
    func signOut(_ completion: @escaping LHAuthErrorResponse) {
        guard let authSession = authSession else {
            return completion(LHAuthError.cannotSignOutIfNotSignedIn)
        }
        
        self.dataStore.delete { (error) in
            guard error == nil else {
                return completion(LHAuthError.failedToRemoveUserSessionData(error!.localizedDescription))
            }
            completion(nil)
        }
    }
    
    func isAuthenticated(_ completion: @escaping LHAuthResponse) {
        dataStore.readAuthSession { (authSession, error) in
            guard error == nil else {
                return completion(nil, LHAuthError.failedToReadLocalAuthSession(error!.localizedDescription))
            }
            
            guard let authSession = authSession else {
                return completion(nil, nil)
            }
            
            self.remoteAuthProvider.isValidAuthSession(authSession: authSession) { (isValidAuthSession, error) in
                guard error == nil else {
                    return completion(nil, LHAuthError.failedToValidateAuthSession(error!.localizedDescription))
                }
                
                guard let isValidAuthSession = isValidAuthSession else {
                    return completion(nil, LHAuthError.failedToValidateAuthSession("❌ Remote returned neither errors nor an auth session? ❌"))
                }
                
                if isValidAuthSession {
                    self.authSession = authSession
                    completion(authSession, nil)
                } else {
                    self.dataStore.delete { (error) in
                        guard error == nil else {
                            let msg = """
                            Cached auth session is no longer valid with your remote AuthProvider. \
                            Encountered error while attempting to flush cache: \(error!.localizedDescription)
                            """
                            return completion(nil, LHAuthError.failedToRemoveUserSessionData(msg))
                        }
                        completion(nil, nil)
                    }
                }
            }
        }
    }
}
