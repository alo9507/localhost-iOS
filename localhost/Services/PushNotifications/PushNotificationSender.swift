//
//  PushNotificationSender.swift
//  Contact
//
//  Created by Andrew O'Brien on 11/17/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation
import UIKit

class PushNotificationSender {
    func sendPushNotification(to token: String, title: String, body: String, senderId: String = "", target: String = "") {
        let urlString = "https://fcm.googleapis.com/fcm/send"
        let url = NSURL(string: urlString)!
        let paramString: [String : Any] =
            [
                "apns": [
                    "payload" : [
                        "aps" : [
                            "alert" : [
                                "title" : "I OVVERIDE TITLE",
                                "body" : "I OVERRIDE BODY"
                            ],
                            "thread_id": "chat-\(senderId)"
                        ]
                    ]
                ],
                "to" : token,
                "notification" : ["title" : title, "body" : body, "thread_identifier": "chat-\(senderId)", "thread_id": "chat-\(senderId)"],
                "data" : ["senderId" : senderId, "target": target]
        ]
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject:paramString, options: [.prettyPrinted])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=AAAA1JYb2TM:APA91bGs2BaDYsGYzC4C6V8Pvg1nZA4GT9CDbv35QsuC1NhFXziBYS_sCoPRkQuO1YKw7WExVFLqIW0vShzDhCWNFBRl7Ak-8Zj9i1dNtHRW22wLGdlWh4unJi9CjGXzzN0i9EbRZuQj", forHTTPHeaderField: "Authorization")
        
        let task =  URLSession.shared.dataTask(with: request as URLRequest)  { (data, response, error) in
            do {
                if let jsonData = data {
                    if let jsonDataDict  = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                        NSLog("Received data:\n\(jsonDataDict))")
                    }
                }
            } catch let err as NSError {
                print(err.debugDescription)
            }
        }
        task.resume()
    }
}
