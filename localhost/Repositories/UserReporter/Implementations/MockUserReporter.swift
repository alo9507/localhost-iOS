//
//  MockUserReporter.swift
//  Contact
//
//  Created by Andrew O'Brien on 1/1/20.
//  Copyright © 2020 Andrew O'Brien. All rights reserved.
//

import Foundation

class MockUserReporter: UserReporter {
    func report(sourceUser: User, destUser: User, reason: ReportingReason, completion: @escaping LHResult<Bool>) {
        
    }
    
    func block(sourceUser: User, destUser: User, completion: @escaping LHResult<Bool>) {
        
    }
    
    func userIDsBlockedOrReported(by user: User, completion: @escaping LHResult<Set<String>>) {
        
    }
}
