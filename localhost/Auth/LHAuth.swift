//
//  LHAuth.swift
//  AuthFramework
//
//  Created by Andrew O'Brien on 12/11/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation

public struct LHAuth {
    static public func configure(for authProvider: LHAuthProvider, with dataStore: LHAuthDataStore? = nil) {
        manager.configure(for: authProvider, with: dataStore)
    }
    
    static public let manager: LHAuthManager = AuthManager()
    
    static public var session: LHAuthSession? {
        return manager.authSession
    }
}
