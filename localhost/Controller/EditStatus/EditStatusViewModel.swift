//
//  EditStatusViewModel.swift
//  Contact
//
//  Created by Andrew O'Brien on 11/10/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation

protocol EditStatusViewModelDelegate {
    func currentUserSession(_ userSession: UserSession?)
    func dismissSelf()
    func clearStatusTextField()
    func wordCount(_ wordCount: Int)
}

class EditStatusViewModel: UserSessionStoreSubscriber {
    func userSessionUpdated(_ userSession: UserSession) {
        self.delegate?.currentUserSession(userSession)
    }
    
    var currentUser: User  {
        return UserSessionStore.shared.userSession.user
    }
    
    var userSession: UserSession  {
          return UserSessionStore.shared.userSession
      }
    
    var delegate: EditStatusViewModelDelegate? {
        didSet {
            self.delegate?.wordCount(0)
        }
    }
    
    var userRepository: UserRepository
    var userSessionRepository: UserSessionRepository
    
    var statusText: String {
        didSet {
            let charCount = statusText.count
            self.delegate?.wordCount(charCount)
        }
    }
    
    init(
        userRepository: UserRepository,
        userSessionRepository: UserSessionRepository
    ) {
        self.userRepository = userRepository
        self.userSessionRepository = userSessionRepository
        self.statusText = ""
        UserSessionStore.subscribe(self)
    }
    
    @objc
    func postStatus() {
        userSessionRepository.updateUserSession(data: ["whatAmIDoing": statusText]) { (userSession, error) in
            if error != nil { return print(error!.localizedDescription) }
            self.delegate?.clearStatusTextField()
            self.delegate?.dismissSelf()
        }
    }
    
    @objc
    func cancel() {
        self.delegate?.clearStatusTextField()
        self.delegate?.dismissSelf()
    }
}
