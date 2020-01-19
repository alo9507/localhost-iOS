//
//  MockAuthManager.swift
//  Contact
//
//  Created by Andrew O'Brien on 1/2/20.
//  Copyright © 2020 Andrew O'Brien. All rights reserved.
//

import Foundation

class MockAuthManager: LHAuthManager {
    var authProvider: LHAuthProvider?
    
    var dataStore: LHAuthDataStore
    
    var authSession: LHAuthSession? = LHAuthSession(token: "MOCK_AUTH_TOKEN", refreshToken: "", uid: "MOCK_USER_ID")
    
    init(authProvider: LHAuthProvider?, dataStore: LHAuthDataStore) {
        self.authProvider = authProvider
        self.dataStore = dataStore
    }
    
    convenience init() {
        self.init(authProvider: nil, dataStore: KeychainDataStore())
    }
    
    func clear(_ completion: @escaping LHAuthErrorResponse) {
        
    }
    func signIn(email: String?, password: String?, phoneNumber: String?, _ completion: @escaping LHAuthResponse) {
        
    }
    
    func signOut(_ completion: @escaping LHAuthErrorResponse) {
        completion(nil)
    }
    
    func signUp(email: String, password: String, _ completion: @escaping LHAuthResponse) {
        
    }
    
    func isAuthenticated(_ completion: @escaping LHAuthResponse) {
        
        completion(authSession, nil)
    }
    
}
