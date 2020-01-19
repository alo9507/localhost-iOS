//
//  UserSessionCoding.swift
//  Contact
//
//  Created by Andrew O'Brien on 8/20/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation

public protocol UserSessionCoding {
    func encode(userSession: UserSession) -> Data
    func decode(data: Data) -> UserSession
}
