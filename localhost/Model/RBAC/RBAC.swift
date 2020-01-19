//
//  RBAC.swift
//  Contact
//
//  Created by Andrew O'Brien on 9/2/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

internal var rules = [Policy]()

public protocol UserAction {
    init()
    static var userAction: UserAction.Type { get }
}

public extension UserAction {
    static var userAction: UserAction.Type { return Self.self }
}

public protocol Role {
    init()
    static func shouldBeAbleTo (_ action: UserAction.Type) -> Policy
    func can (_ userAction: UserAction) -> Bool
}

public extension Role {
    static func shouldBeAbleTo(_ userAction: UserAction.Type) -> Policy {
        let rule = Policy(userAction: userAction.init(), role: self.init())
        rule.condition = { role, userAction in
            guard role is Self else {
                return false
            }
            return true
        }
        rules.append(rule)
        return rule
    }
    
    func can (_ userAction: UserAction) -> Bool {
        return rules.reduce(false) {
            $1.apply(role: self, userAction: userAction) || $0
        }
    }
}
