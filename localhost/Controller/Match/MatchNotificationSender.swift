//
//  MatchNotificationSender.swift
//  DatingApp
//
//  Created by Florian Marcu on 1/27/19.
//  Copyright © 2019 Instamobile. All rights reserved.
//

import UIKit

class MatchNotificationSender {
    func sendNotificationIfPossible(user: User, recipient: User) {
        let sender = PushNotificationSender()
        sender.sendPushNotification(to: recipient.pushToken, title: "Instaswipey", body: "You've just got a new match. Send them a message.")
    }
}
