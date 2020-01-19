//
//  AuthManangerProtocol.swift
//  AuthFramework
//
//  Created by Andrew O'Brien on 12/11/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation

public protocol LHAuthManager {
    var authProvider: LHAuthProvider? { get }
    
    var dataStore: LHAuthDataStore { get }
    
    var authSession: LHAuthSession? { get }
    
    func clear(_ completion: @escaping LHAuthErrorResponse)
    
    func configure(for authProvider: LHAuthProvider, with dataStore: LHAuthDataStore?)
    
    func signIn(email: String?, password: String?, phoneNumber: String?, _ completion: @escaping LHAuthResponse)
    
    func signOut(_ completion: @escaping LHAuthErrorResponse)
    
    func signUp(email: String, password: String, _ completion: @escaping LHAuthResponse)
    
    func isAuthenticated(_ completion: @escaping LHAuthResponse)
}

extension LHAuthManager {
    func configure(for authProvider: LHAuthProvider, with dataStore: LHAuthDataStore? = nil) {
        configure(for: authProvider, with: dataStore)
    }
}
