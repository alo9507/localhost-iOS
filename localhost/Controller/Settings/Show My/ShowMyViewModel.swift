//
//  ShowMyViewModel.swift
//  Contact
//
//  Created by Andrew O'Brien on 12/27/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation

protocol ShowMyViewModelDelegate {
    func userSession(_ userSession: UserSession)
    func dismissSelf()
}

class ShowMyViewModel: UserSessionStoreSubscriber {
    func userSessionUpdated(_ userSession: UserSession) {
        self.showMySelections = userSession.user.showMy
        self.delegate?.userSession(userSession)
    }
    
    var currentUser: User {
        return UserSessionStore.shared.userSession.user
    }
    
    var userSession: UserSession {
           return UserSessionStore.shared.userSession
    }
    
    var userSessionRepository: UserSessionRepository
    
    var showMySelections: [String] = []
    
    var delegate: ShowMyViewModelDelegate?
    
    init(userSessionRepository: UserSessionRepository) {
        self.userSessionRepository = userSessionRepository
        
        UserSessionStore.subscribe(self)
    }
    
    @objc
    func save() {
        userSessionRepository.updateUserSession(data: ["showMy": showMySelections]) { (userSession, error) in
            if error != nil { return print(error!.localizedDescription) }
            guard let userSession = userSession else { return print(LHError.illegalState("Nil User : Nil Error")) }
            print("Show My Settings changed to: \(self.showMySelections)")
            self.delegate?.dismissSelf()
        }
    }
}
