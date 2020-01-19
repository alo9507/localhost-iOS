//
//  ChatMessage.swift
//  ChatApp
//
//  Created by Florian Marcu on 8/20/18.
//  Copyright © 2018 Instamobile. All rights reserved.
//

import Firebase
import FirebaseFirestore
import MessageKit

class LHMediaItem: MediaItem {
    var url: URL? = nil
    var image: UIImage? = nil
    var placeholderImage: UIImage
    var size: CGSize
    init(url: URL?, image: UIImage? = nil) {
        self.url = url
        self.image = image
        self.placeholderImage = UIImage(named: "noProfilePhoto")!
        self.size = CGSize(width: 500, height: 500)
    }
}

class ChatMessage: GenericBaseModel, MessageType {
    var id: String?

    var sentDate: Date

    var kind: MessageKind

    lazy var sender: SenderType = Sender(senderId: lhSender.uid , displayName: lhSender.uid)

    var lhSender: User
    var lhRecipient: User
    var seenByRecipient: Bool

    var messageId: String {
        return id ?? UUID().uuidString
    }

    var image: UIImage? = nil {
        didSet {
            self.kind = .photo(LHMediaItem(url: downloadURL, image: self.image))
        }
    }
    var downloadURL: URL? = nil
    let content: String

    init(messageId: String, messageKind: MessageKind, createdAt: Date, atcSender: User, recipient: User, seenByRecipient: Bool) {
        self.id = messageId
        self.kind = messageKind
        self.sentDate = createdAt
        self.lhSender = atcSender
        self.lhRecipient = recipient
        self.seenByRecipient = seenByRecipient

        switch messageKind {
        case .text(let text):
            self.content = text
        default:
            self.content = ""
        }
    }

    init(user: User, image: UIImage, url: URL) {
        self.image = image
        content = ""
        sentDate = Date()
        id = nil
        let mediaItem = LHMediaItem(url: url, image: nil)
        self.kind = MessageKind.photo(mediaItem)
        self.lhSender = user
        self.lhRecipient = user
        self.seenByRecipient = true
    }

    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        guard let sentDate = data["created"] as? Timestamp else {
            return nil
        }
        guard let senderID = data["senderID"] as? String else {
            return nil
        }
        guard let senderFirstName = data["senderFirstName"] as? String else {
            return nil
        }
        guard let senderLastName = data["senderLastName"] as? String else {
            return nil
        }
        guard let senderProfilePictureURL = data["senderProfilePictureURL"] as? String else {
            return nil
        }
        guard let recipientID = data["recipientID"] as? String else {
            return nil
        }
        guard let recipientFirstName = data["recipientFirstName"] as? String else {
            return nil
        }
        guard let recipientLastName = data["recipientLastName"] as? String else {
            return nil
        }
        guard let recipientProfilePictureURL = data["recipientProfilePictureURL"] as? String else {
            return nil
        }

        id = document.documentID

        self.sentDate = sentDate.dateValue()
        self.lhSender = User(uid: senderID, firstName: senderFirstName, lastName: senderLastName, profileImageUrl: senderProfilePictureURL)
        self.lhRecipient = User(uid: recipientID, firstName: recipientFirstName, lastName: recipientLastName, profileImageUrl: recipientProfilePictureURL)

        if let content = data["content"] as? String {
            self.content = content
            downloadURL = nil
            self.kind = MessageKind.text(content)
        } else if let urlString = data["url"] as? String, let url = URL(string: urlString) {
            downloadURL = url
            self.content = ""
            let mediaItem = LHMediaItem(url: url, image: nil)
            self.kind = MessageKind.photo(mediaItem)
        } else {
            return nil
        }
        self.seenByRecipient = true
    }

    required init(jsonDict: [String: Any]) {
        fatalError()
    }

    var description: String {
        return self.messageText
    }

    var messageText: String {
        switch kind {
        case .text(let text):
            return text
        default:
            return ""
        }
    }
    
    var channelId: String {
        let id1 = (lhRecipient.uid)
        let id2 = (lhSender.uid)
        return id1 < id2 ? id1 + id2 : id2 + id1
    }
}

extension ChatMessage: DatabaseRepresentation {

    var representation: [String : Any] {
        var rep: [String : Any] = [
            "created": sentDate,
            "senderID": lhSender.uid,
            "senderFirstName": lhSender.firstName,
            "senderLastName": lhSender.lastName,
            "senderProfilePictureURL": lhSender.profileImageUrl,
            "recipientID": lhRecipient.uid,
            "recipientFirstName": lhRecipient.firstName,
            "recipientLastName": lhRecipient.lastName,
            "recipientProfilePictureURL": lhSender.profileImageUrl,
        ]

        if let url = downloadURL {
            rep["url"] = url.absoluteString
        } else {
            rep["content"] = content
        }

        return rep
    }

}

extension ChatMessage: Comparable {

    static func == (lhs: ChatMessage, rhs: ChatMessage) -> Bool {
        return lhs.id == rhs.id
    }

    static func < (lhs: ChatMessage, rhs: ChatMessage) -> Bool {
        return lhs.sentDate < rhs.sentDate
    }
}

import Foundation

protocol DatabaseRepresentation {
    var representation: [String: Any] { get }
}
