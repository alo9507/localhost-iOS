//
//  UserSession.swift
//  Contact
//
//  Created by Andrew O'Brien on 8/20/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

public class UserSession: Codable {
    
    public let user: User
    public let authSession: LHAuthSession
    
    public init(user: User, authSession: LHAuthSession) {
        self.user = user
        self.authSession = authSession
    }
}
