//
//  UserSessionCoder.swift
//  Contact
//
//  Created by Andrew O'Brien on 8/20/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation

public class UserSessionPropertyListCoder: UserSessionCoding {

    public init() {}
    
    public func encode(userSession: UserSession) -> Data {
        return try! PropertyListEncoder().encode(userSession)
    }
    
    public func decode(data: Data) -> UserSession {
        return try! PropertyListDecoder().decode(UserSession.self, from: data)
    }
}
