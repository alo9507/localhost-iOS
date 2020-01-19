//
//  ProfileDetailViewModel.swift
//  Contact
//
//  Created by Andrew O'Brien on 8/15/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation

protocol ProfileDetailViewModelDelegate: class {
    func currentUserSession(_ userSession: UserSession)
    func error(_ error: LHError)
    func optimisticallyUpdateInteractionIcon()
    func rollbackInteractionIcon()
}

class ProfileDetailViewModel: UserSessionStoreSubscriber {
    func userSessionUpdated(_ userSession: UserSession) {
        print("Profile Detail was notified")
        self.delegate?.currentUserSession(userSession)
    }
    
    var userSession: UserSession {
        return UserSessionStore.shared.userSession
    }
    
    let socialGraphRepository: SocialGraphRepository
    let userRepository: UserRepository
    let featuredUser: User
    let origin: Origin
    
    var inboundNod: Bool {
        return UserSessionStore.shared.userSession.user.inboundNotOutbound.contains(featuredUser.uid)
    }
    
    var presentOptionsMenu: (() -> Void)?
    var pushChatRoom: ((User) -> Void)?
    var presentNodComposer: (() -> Void)?
    var noChat: (() -> Void)?
    var itsAMatch: (() -> Void)?
    
    weak var delegate: ProfileDetailViewModelDelegate? {
        didSet {
            delegate?.currentUserSession(UserSessionStore.shared.userSession)
        }
    }
    
    init(
        featuredUser: User,
        origin: Origin,
        userRepository: UserRepository,
        socialGraphRepository: SocialGraphRepository
    ) {
        self.featuredUser = featuredUser
        self.userRepository = userRepository
        self.socialGraphRepository = socialGraphRepository
        self.origin = origin
        
        UserSessionStore.subscribe(self)
    }
    
}

// MARK: Event Handlers
extension ProfileDetailViewModel {
    
    @objc
    func showOptionsMenu() {
        self.presentOptionsMenu?()
    }
    
    @objc
    func connectButtonTapped() {
        switch userSession.user.determineUserRelationship(userUid: featuredUser.uid) {
        case .match:
            self.pushChatRoom?(featuredUser)
        case .inbound:
            self.presentNodComposer?()
        case .outbound:
            self.noChat?()
        case .noRelation:
            self.presentNodComposer?()
        }
    }
    
    @objc
    func makeSelfInvisible() {
        print("add to blocked?")
    }
    
    @objc
    func sendNod(message: String? = nil) {
        self.delegate?.optimisticallyUpdateInteractionIcon()
        let nod = Nod(sender: userSession.user.uid, recipient: featuredUser.uid, type: "like", message: message)
        
        socialGraphRepository.sendNod(author: nod.sender, recipient: nod.recipient, type: "like", message: nod.message) { (success, error) in
            if error != nil {
                self.delegate?.rollbackInteractionIcon()
                self.delegate?.error(LHError.failedToDoSomething("Error"))
            }
            if self.userSession.user.determineUserRelationship(userUid: self.featuredUser.uid) == UserRelationship.match {
                self.itsAMatch?()
            }
            let sender = PushNotificationSender()
            sender.sendPushNotification(
                to: self.featuredUser.pushToken,
                title: "\(self.userSession.user.firstName) nodded at you!",
                body: nod.message ?? "",
                senderId: self.userSession.user.uid,
                target: "nod"
            )
        }
    }
}
