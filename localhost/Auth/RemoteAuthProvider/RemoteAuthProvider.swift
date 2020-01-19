//
//  RemoteAuthProvider.swift
//  AuthFramework
//
//  Created by Andrew O'Brien on 12/18/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation

public typealias LHAuthValidationResponse = (Bool?, LHAuthError?) -> Void
public typealias LHAuthResponse = (LHAuthSession?, LHAuthError?) -> Void
public typealias LHAuthErrorResponse = (LHAuthError?) -> Void

public protocol RemoteAuthProvider {
    func signIn(email: String?, password: String?, phoneNumber: String?, _ completion: @escaping LHAuthResponse)
    func signOut(authSession: LHAuthSession, _ completion: @escaping LHAuthErrorResponse)
    func signUp(email: String, password: String, completion: @escaping LHAuthResponse)
    func isValidAuthSession(authSession: LHAuthSession, _ completion: @escaping LHAuthValidationResponse)
}
