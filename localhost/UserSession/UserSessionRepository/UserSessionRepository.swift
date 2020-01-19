//
//  UserSessionRepository.swift
//  Contact
//
//  Created by Andrew O'Brien on 8/20/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation

public protocol UserSessionRepository: class {
    func readUserSession(completion: @escaping LHResult<UserSession>)
    func signUp(registeringUser: User, profileImageData: Data, completion: @escaping LHResult<UserSession>)
    func signIn(email: String, password: String, completion: @escaping LHResult<UserSession>)
    func signOut(completion: @escaping LHAuthErrorResponse)
    func updateUserSession(data: Dictionary<String, Any>, completion: @escaping LHResult<UserSession>)
}
