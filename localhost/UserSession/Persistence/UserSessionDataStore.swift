//
//  UserSessionDataStore.swift
//  Contact
//
//  Created by Andrew O'Brien on 8/20/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation

public protocol UserSessionDataStore: Codable {
    func readUserSession(completion: @escaping LHResult<UserSession>)
    func save(userSession: UserSession, completion: @escaping LHResult<UserSession>)
    func delete(completion: @escaping LHResult<String>)
}
