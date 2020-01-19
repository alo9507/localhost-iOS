//
//  AuthSession.swift
//  AuthFramework
//
//  Created by Andrew O'Brien on 12/11/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation

public class LHAuthSession: Codable {
    
    public let token: String
    
    public var uid: String = ""
    
    public let refreshToken: String
    
    public init(token: String, refreshToken: String, uid: String = "") {
        self.token = token
        self.refreshToken = refreshToken
        self.uid = uid
    }
}
