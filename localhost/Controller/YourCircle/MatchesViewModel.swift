//
//  MatchesViewModel.swift
//  Contact
//
//  Created by Andrew O'Brien on 11/9/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.

import Foundation

protocol MatchesViewModelDelegate: class {
    func userSession(_ userSession: UserSession)
    func matchedUsersReceived(_ matchedUsersReceived: [User])
    func noMatchedUsers(_ noMatchedUsers: Bool)
    func nodsReceived(_ nodsReceived: [User])
    func noNodsReceived(_ noNodsReceived: Bool)
    func error(_ error: LHError)
}

class MatchesViewModel: UserSessionStoreSubscriber {
    func userSessionUpdated(_ userSession: UserSession) {
        self.delegate?.userSession(userSession)
        self.loadMatches()
        self.loadNods()
    }
    
    var delegate: MatchesViewModelDelegate? {
        didSet {
            delegate?.userSession(self.userSession)
        }
    }
    
    var userSession: UserSession {
        return UserSessionStore.shared.userSession
    }
    
    var socialGraphRepository: SocialGraphRepository
    
    var showProfileDetail: ((User, Origin) -> Void)?
    
    init(
        socialGraphRepository: SocialGraphRepository
    ) {
        self.socialGraphRepository = socialGraphRepository
        UserSessionStore.subscribe(self)
    }
    
    public func loadMatches() {
        socialGraphRepository.fetchMatches(for: userSession.user) { (matches, error) in
            if error != nil { return print(error!.localizedDescription) }
            guard let matches = matches else { return print("❌❌❌NO MATCHES???❌❌❌") }
            
            if !matches.isEmpty {
                guard let delegate = self.delegate else { return print("Matches - Delegate not set!") }
                delegate.matchedUsersReceived(matches)
            } else {
                self.delegate?.noMatchedUsers(true)
            }
        }
    }
    
    public func loadNods() {
        socialGraphRepository.getInboundNotOutboundUsers(currentUser: userSession.user) { (inboundNodUsers, error) in
            if error != nil { return print(error!.localizedDescription) }
            guard let inboundNodUsers = inboundNodUsers else { return print(LHError.illegalState("Nil User : Nil Error")) }
            
            if !inboundNodUsers.isEmpty {
                guard let delegate = self.delegate else { return print("Nods - Delegate not set!") }
                delegate.nodsReceived(inboundNodUsers)
            } else {
                self.delegate?.noNodsReceived(true)
            }
        }
    }
}
