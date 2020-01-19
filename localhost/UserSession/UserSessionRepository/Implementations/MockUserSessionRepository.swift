//
//  MockUserSessionRepository.swift
//  Contact
//
//  Created by Andrew O'Brien on 1/12/20.
//  Copyright © 2020 Andrew O'Brien. All rights reserved.
//

import Foundation

public class MockUserSessionRepository: UserSessionRepository {
    public func updateUserSession(data: Dictionary<String, Any>, completion: @escaping LHResult<UserSession>) {
        
    }
    
    let mockUserSession: UserSession = {
        let mockUser = User(jsonDict: [:])
        mockUser.firstName = "Mocker"
        mockUser.isVisible = true
        mockUser.uid = "MOCK_USER_ID"
        
        let mockAuthSession = LHAuthSession(token: "MOCK_AUTH_TOKEN", refreshToken: "", uid: mockUser.uid)
        return UserSession(user: mockUser, authSession: mockAuthSession)
    }()
    
    public func readUserSession(completion: @escaping LHResult<UserSession>) {
        completion(mockUserSession, nil)
    }
    
    public func signUp(registeringUser: User, profileImageData: Data, completion: @escaping LHResult<UserSession>) {
        completion(mockUserSession, nil)
    }
    
    public func signIn(email: String, password: String, completion: @escaping LHResult<UserSession>) {
        completion(mockUserSession, nil)
    }
    
    public func signOut(completion: @escaping LHAuthErrorResponse) {
        completion(nil)
    }
    
}
