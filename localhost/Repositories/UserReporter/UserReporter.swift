//
//  UserReporter.swift
//  Contact
//
//  Created by Andrew O'Brien on 11/21/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation

protocol UserReporter: class {
    func report(sourceUser: User, destUser: User, reason: ReportingReason, completion: @escaping LHResult<Bool>)
    func block(sourceUser: User, destUser: User, completion: @escaping LHResult<Bool>)
    func userIDsBlockedOrReported(by user: User, completion: @escaping LHResult<Set<String>>)
}
