//
//  PushNotificationManager.swift
//  DatingApp
//
//  Created by Florian Marcu on 1/27/19.
//  Copyright © 2019 Instamobile. All rights reserved.
//

import Firebase
import FirebaseFirestore
import FirebaseMessaging
import UIKit
import UserNotifications

class PushNotificationManager: NSObject, MessagingDelegate, UNUserNotificationCenterDelegate {
    let user: User
    init(user: User) {
        self.user = user
        super.init()
    }

    func registerForPushNotifications() {
        if #available(iOS 10.0, *) {
            // For iOS 10 display notifications sent on APNS
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            // For iOS 10 data message sent by FCM
            Messaging.messaging().delegate = self
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }

        UIApplication.shared.registerForRemoteNotifications()
        updateFirestorePushTokenIfNeeded()
    }

    func updateFirestorePushTokenIfNeeded() {
        if let token = Messaging.messaging().fcmToken {
            let usersRef = Firestore.firestore().collection("users").document(user.uid)
            usersRef.setData(["fcmToken": token], merge: true)
        }
    }

    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("DID RECEIVE REMOTE MESSAGE: \(remoteMessage.appData)")
    }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        updateFirestorePushTokenIfNeeded()
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("user clicked on the notification: \(response)")
        print("USER INFOok: \(response.notification.request.content.userInfo)")
        let userInfo = response.notification.request.content.userInfo
        let targetValue = userInfo["target"] as? String ?? "0"

        let userId = userInfo["userId"]
        
        if targetValue == "message" {

        } else if targetValue == "nod" {
            
        }

        completionHandler()
    }
    
    // The callback to handle data message received via FCM - BACKGROUND / ClOSED
    func applicationReceivedRemoteMessage(_ remoteMessage: MessagingRemoteMessage) {
        print(remoteMessage.appData)
    }

    // This method will be called when app received push notifications - FOREGROUND
    // By not calling the completionHandler you suppress showing the notification
    // CHeck a) current VC b) current channel to see if its the one from the message
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {}

}
