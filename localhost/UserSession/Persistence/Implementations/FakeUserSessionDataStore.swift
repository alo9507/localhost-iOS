//
//  FakeUserSessionDataStore.swift
//  Contact
//
//  Created by Andrew O'Brien on 8/20/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation

public class FakeUserSessionDataStore: UserSessionDataStore {
    // MARK: - Properties
    let hasToken: Bool
    
    // MARK: - Methods
    init(hasToken: Bool) {
        self.hasToken = hasToken
    }
    
    public func save(userSession: UserSession, completion: @escaping LHResult<UserSession>) {
        completion(userSession, nil)
    }
    
    public func delete(completion: @escaping LHResult<String>) {
        completion("Successfully removed user", nil)
    }
    
    public func readUserSession(completion: @escaping LHResult<UserSession>) {
        switch hasToken {
        case true:
            return runHasToken(completion: completion)
        case false:
            return runDoesNotHaveToken(completion: completion)
        }
    }
    
    public func runHasToken(completion: @escaping LHResult<UserSession>) {
        print("Try to read user session from fake disk...")
        print("  simulating having user session with token 4321...")
        print("  returning user session with token 4321...")
        let user = User(jsonDict: [:])
        user.uid = "MOCK_USER_ID"
        let authSession = LHAuthSession(token: "1234", refreshToken: "", uid: user.uid)
        completion(UserSession(user: user, authSession: authSession), nil)
    }
    
    func runDoesNotHaveToken(completion: @escaping LHResult<UserSession>) {
        print("Try to read user session from fake disk...")
        print("  simulating empty disk...")
        print("  returning nil...")
        completion(nil, nil)
    }
}
