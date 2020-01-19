//
//  LocalhostUserSessionRepository.swift
//  Contact
//
//  Created by Andrew O'Brien on 8/21/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation

// should be the only agent making Store updates, i.e. runtime user
public class LocalhostUserSessionRepository: UserSessionRepository {
    let authManager: LHAuthManager
    let userRepository: UserRepository
    let dataStore: UserSessionDataStore
    
    // MARK: - Methods
    public init(
        dataStore: UserSessionDataStore,
        authManager: LHAuthManager = LHAuth.manager,
        userRepository: UserRepository
        ) {
        self.dataStore = dataStore
        self.authManager = authManager
        self.userRepository = userRepository
    }
    
    public func signIn(email: String, password: String, completion: @escaping LHResult<UserSession>) {
        authManager.signIn(email: email, password: password, phoneNumber: nil) { (authSession, error) in
            if error != nil {
                completion(nil, LHError.failedToDoSomething(LHAuthError.failedToSignInWithRemote(error!.localizedDescription).localizedDescription))
            }
            
            guard let authSession = authSession else {
                completion(nil, LHError.failedToDoSomething(LHAuthError.unknownError("No errors, but also no AuthSession?").localizedDescription))
                return
            }
            
            self.userRepository.getUser(uid: authSession.uid, completion: { (user, error) in
                if error != nil { return completion(nil, LHError.failedToDoSomething("Failed to get user: \(error!)")) }
                guard let user = user else { return completion(nil, LHError.illegalState("Nil User : Nil Error")) }
                
                let userSession = UserSession(user: user, authSession: LHAuthSession(token: "FAKE_TOKEN", refreshToken: "", uid: user.uid))
                self.dataStore.save(userSession: userSession) { (userSession, error) in
                    if error != nil { return print(error!.localizedDescription) }
                    guard let userSession = userSession else { return completion(nil, LHError.illegalState("Nil User : Nil Error")) }
                    
                    UserSessionStore.shared.userSession(userSession)
                    completion(userSession, nil)
                }
            })
        }
    }
    
    public func readUserSession(completion: @escaping LHResult<UserSession>) {
        authManager.isAuthenticated { (authSession, error) in
            if error != nil { return print(error!.localizedDescription) }
            guard let authSession = authSession else { return completion(nil, nil) }
            
            self.userRepository.getUser(uid: authSession.uid, completion: { (user, error) in
                if error != nil { return completion(nil, LHError.firebaseError(error!.localizedDescription)) }
                guard let user = user else { return completion(nil, LHError.firebaseError("Failed to fetch latest user: \(authSession.uid)")) }
                let mostRecentUserSession = UserSession(user: user, authSession: authSession)
                
                UserSessionStore.shared.userSession(mostRecentUserSession)
                completion(mostRecentUserSession, nil)
            })
        }
    }
    
    public func signUp(registeringUser: User, profileImageData: Data, completion: @escaping LHResult<UserSession>) {
        authManager.signUp(email: registeringUser.email, password: registeringUser.password) { (authSession, error) in
            if error != nil { return print(error!.localizedDescription) }
            guard let authSession = authSession else { return print("No User Session?") }
            
            self.userRepository.createUser(registeringUser: registeringUser, profileImageData: profileImageData, authSession: authSession) { (user, error) in
                if error != nil { return print(error!.localizedDescription) }
                guard let user = user else { return completion(nil, LHError.illegalState("Nil User : Nil Error")) }
                
                let userSession = UserSession(user: user, authSession: authSession)
                
                UserSessionStore.shared.userSession(userSession)
                completion(userSession, nil)
            }
        }
    }
    
    public func signOut(completion: @escaping LHAuthErrorResponse) {
        return authManager.signOut() { (error) in
            if error != nil { return completion(LHAuthError.failedToSignOutWithRemote(error!.localizedDescription)) }
            completion(nil)
        }
    }
    
    /// The central method for updating anything related to the current user
    /// - Parameters:
    ///   - data: A dictionary of data to update on the current user
    ///   - completion: Called with the updated user session after it is updated on remote, saved to cache, and finally propogated to all UserSessionStore subscribers
    public func updateUserSession(data: Dictionary<String, Any>, completion: @escaping LHResult<UserSession>) {
        // adding a patch operation with a Dictionary on User object would let you skip this call and also do optimistic updates one user
        // call optimistic(updateUserSession)
        userRepository.updateUser(userUid: UserSessionStore.user.uid, data: data) { (user, error) in
            if error != nil {
                // call revert
                completion(nil, LHError.failedToDoSomething(error!.localizedDescription))
            }
            guard let _ = user else { return completion(nil, LHError.illegalState("Nil User : Nil Error")) }
            
            self.userRepository.getUser(uid: UserSessionStore.user.uid, completion: { (user, error) in
                if error != nil { return print(error!.localizedDescription) }
                guard let user = user else { return completion(nil, LHError.illegalState("Nil User : Nil Error")) }
                
                let updatedUserSession = UserSession(user: user, authSession: UserSessionStore.shared.userSession.authSession)
                
                self.dataStore.save(userSession: updatedUserSession) { (updatedUserSession, error) in
                    if error != nil { return completion(nil, LHError.failedToDoSomething("Failed to update user session")) }
                    guard let updatedUserSession = updatedUserSession else { return completion(nil, LHError.illegalState("Nil User : Nil Error")) }
                    
                    UserSessionStore.shared.userSession(updatedUserSession)
                    completion(updatedUserSession, nil)
                }
            })
        }
    }
}
