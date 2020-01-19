//
//  ChatChannel.swift
//  ChatApp
//
//  Created by Florian Marcu on 8/26/18.
//  Copyright © 2018 Instamobile. All rights reserved.
//

import FirebaseFirestore

struct ChatChannel: GenericBaseModel {
    var description: String {
        return id
    }

    let id: String
    let name: String
    let lastMessageDate: Date
    var participants: [User]
    let lastMessage: String

    init(id: String, name: String) {
        self.id = id
        self.name = name
        self.participants = []
        self.lastMessageDate = Date().oneYearAgo
        self.lastMessage = ""
    }

    init?(document: DocumentSnapshot) {
        guard let data = document.data() else { return nil }
        var name: String = ""
        if let tmp = data["name"] as? String {
            name = tmp
        }
        self.id = document.documentID
        self.name = name
        self.participants = []

        var date = Date().oneYearAgo
        if let d = data["lastMessageDate"] as? Timestamp {
            date = d.dateValue()
        }
        self.lastMessageDate = date
        var lastMessage = ""
        if let m = data["lastMessage"] as? String {
            lastMessage = m
        }
        self.lastMessage = lastMessage
    }

    init(jsonDict: [String: Any]) {
        fatalError()
    }
}

extension ChatChannel: DatabaseRepresentation {
    var representation: [String : Any] {
        var rep = ["name": name]
        rep["id"] = id
        return rep
    }
}

extension ChatChannel: Comparable {

    static func == (lhs: ChatChannel, rhs: ChatChannel) -> Bool {
        return lhs.id == rhs.id
    }

    static func < (lhs: ChatChannel, rhs: ChatChannel) -> Bool {
        return lhs.name < rhs.name
    }

}
