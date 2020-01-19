//
//  LHAuthDataStore.swift
//  AuthFramework
//
//  Created by Andrew O'Brien on 12/18/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation

public protocol LHAuthDataStore {
    func readAuthSession(_ completion: @escaping LHAuthResponse)
    func save(authSession: LHAuthSession, _ completion: @escaping LHAuthErrorResponse)
    func delete(_ completion: @escaping LHAuthErrorResponse)
}
