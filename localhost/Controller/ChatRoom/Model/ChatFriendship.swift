//
//  ChatFriendship.swift
//  ChatApp
//
//  Created by Florian Marcu on 6/5/19.
//  Copyright © 2019 Instamobile. All rights reserved.
//

import UIKit

enum FriendshipType {
    case mutual
    case inbound
    case outbound
}

class ChatFriendship: GenericBaseModel {

    var currentUser: User
    var otherUser: User
    var type: FriendshipType

    var description: String {
//        return currentUser.description + otherUser.description + String(type.hashValue)
        return "DESCRIPTION"
    }

    init(currentUser: User, otherUser: User, type: FriendshipType) {
        self.currentUser = currentUser
        self.otherUser = otherUser
        self.type = type
    }

    required public init(jsonDict: [String: Any]) {
        fatalError()
    }

}
