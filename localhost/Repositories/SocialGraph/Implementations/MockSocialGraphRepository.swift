//
//  MockSocialGraphRepository.swift
//  Contact
//
//  Created by Andrew O'Brien on 12/31/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

class MockSocialGraphRepository: SocialGraphRepository {
    var userSessionRepository: UserSessionRepository
    
    init(userSessionRepository: UserSessionRepository) {
        self.userSessionRepository = userSessionRepository
    }
    
    func fetchMatches(for user: User, completion: @escaping LHResult<[User]>) {}
    
    func sendNod(author: String, recipient: String, type: String, message: String?, completion: @escaping LHResult<Bool>) {}
    
    func checkIfMutualNodExists(author: String, profile: String, completion: @escaping (Bool) -> Void) {}
    
    func fetchInboundNods(for user: String, completion: @escaping (Set<String>) -> Void) {}
    
    func fetchOutboundNods(for user: String, completion: @escaping (Set<String>) -> Void) {}
    
    func fetchMatches(for user: User, completion: @escaping ([User]) -> Void) {}
    
    func getInboundNotOutboundUsers(currentUser: User, completion: @escaping LHResult<[User]>) {}
}
