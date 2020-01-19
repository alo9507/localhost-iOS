//
//  SocialGraphRepository.swift
//  Contact
//
//  Created by Andrew O'Brien on 12/16/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation

public protocol SocialGraphRepository:  class {
    var userSessionRepository: UserSessionRepository { get set }
    
    func sendNod(author: String, recipient: String, type: String, message: String?, completion: @escaping LHResult<Bool>) -> Void
    func checkIfMutualNodExists(author: String, profile: String, completion: @escaping (_ result: Bool) -> Void) -> Void
    func fetchInboundNods(for user: String, completion: @escaping (Set<String>) -> Void)
    func fetchOutboundNods(for user: String, completion: @escaping (Set<String>) -> Void)
    func fetchMatches(for user: User, completion: @escaping LHResult<[User]>)
    
    func getInboundNotOutboundUsers(currentUser: User, completion: @escaping LHResult<[User]>)
}
