//
//  Nod.swift
//  DatingApp
//
//  Created by Florian Marcu on 2/18/19.
//  Copyright © 2019 Instamobile. All rights reserved.
//

import UIKit

public struct Nod: GenericBaseModel, Hashable, Equatable {
    public static func == (lhs: Nod, rhs: Nod) -> Bool {
        return (lhs.sender == rhs.sender && lhs.recipient == rhs.recipient)
    }

    var sender: String
    var recipient: String
    var type: String
    var message: String?

    init(sender: String, recipient: String, type: String, message: String? = nil) {
        self.sender = sender
        self.recipient = recipient
        self.type = type
        self.message = message
    }

    init(jsonDict representation: [String: Any]) {
        self.sender =  representation["author"] as! String
        self.recipient = representation["recipient"] as! String
        self.type = representation["type"] as! String
        self.message = representation["message"] as? String
    }

    public var description: String {
        return "From: \(self.sender) To: \(self.recipient) Message: \(String(describing: self.message))"
    }
}
