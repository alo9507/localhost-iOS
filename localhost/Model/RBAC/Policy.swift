//
//  Policy.swift
//  Contact
//
//  Created by Andrew O'Brien on 9/2/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

public class Policy {
    let userAction: UserAction
    let role: Role
    var condition: ((Role, UserAction) -> Bool)?
    
    init(userAction: UserAction, role: Role) {
        self.userAction = userAction
        self.role = role
    }
    
    func apply(role: Role, userAction: UserAction) -> Bool {
        return condition?(role, userAction) ?? false
    }
    
    public func when(condition: @escaping (Role, UserAction) -> Bool) {
        self.condition = condition
    }
}
