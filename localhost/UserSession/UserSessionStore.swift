//
//  UserSessionStore.swift
//  Contact
//
//  Created by Andrew O'Brien on 1/3/20.
//  Copyright © 2020 Andrew O'Brien. All rights reserved.
//

/// The protocol implemented by any object (likely a ViewModel) with a need for the most recent UserSession
protocol UserSessionStoreSubscriber: class {
    func userSessionUpdated(_ userSession: UserSession)
}

/// A Redux-like Pub-Sub system for propogating the most recent UserSession across the app
class UserSessionStore {
    static let shared = UserSessionStore()
    private var subscribers: [UserSessionStoreSubscriber] = []
    
    /// Removes the subscriber from the subscribers list to prevent a memory leak with a strong reference
    /// - Parameter unsubscriber:An object (likely a ViewModel) which no longer needs to be updated with the latests UserSession, likely because it is a) not visible or b) deinitializing
    static public func unsubscribe(_ unsubscriber: UserSessionStoreSubscriber) {
        let index = shared.subscribers.firstIndex { (subscriber) -> Bool in
            return subscriber === unsubscriber
        }
        guard let removalIndex = index else {
            fatalError("Cannot unsubscribe \(unsubscriber) because the object never subscribed to UserSessionStore.shared in the first place. Please call UserSessionStore.subscriber(self) in the inititialization of the object you'd like to subscribe, and then UserSessionStore.unsubscribe in the deinit of the viewController referencing you ViewModel")
        }
        shared.subscribers.remove(at: removalIndex)
        print("REMOVED: \(shared.subscribers)")
    }
    
    
    /// Method for subscribing to updates to the shared UserSession
    /// - Parameter subscriber: An object (likely a ViewModel) that would like to be updated with the latest shared UserSession after any changes
    static public func subscribe(_ subscriber: UserSessionStoreSubscriber) {
        shared.subscribers.append(subscriber)
        subscriber.userSessionUpdated(shared.userSession)
        print("ADDED: \(shared.subscribers)")
    }
    
    /// The central UserSession which remains in sync across the app
    public var userSession: UserSession = UserSession(user: User(jsonDict: [:]), authSession: LHAuthSession(token: "", refreshToken: ""))
    
    /// The method called anywhere in the app to update the currently authenticated user's UserSession and publish the changes to the rest of the app
    /// - Parameter userSession: The updated UserSession
    public func userSession(_ userSession: UserSession) {
        self.userSession = userSession
        for subscriber in subscribers {
            subscriber.userSessionUpdated(userSession)
        }
    }
    
    /// Convenience getter for the current User on the most recent shared UserSession
    static public var user: User {
        return shared.userSession.user
    }
}
