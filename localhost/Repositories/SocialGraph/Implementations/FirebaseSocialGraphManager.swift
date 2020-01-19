//
//  FirebaseSocialGraphManager.swift
//  DatingApp
//
//  Created by Florian Marcu on 3/31/19.
//  Copyright © 2019 Instamobile. All rights reserved.
//

import FirebaseFirestore
import UIKit

class FirebaseSocialGraphManager: NSObject, SocialGraphRepository {
    var userSessionRepository: UserSessionRepository
    
   let userRepostitory: UserRepository
    
    init(userRepostitory: UserRepository, userSessionRepository: UserSessionRepository) {
        self.userRepostitory = userRepostitory
        self.userSessionRepository = userSessionRepository
    }
    
    func fetchMatches(for user: User, completion: @escaping LHResult<[User]>) {
        var matches: [User] = []
        userRepostitory.getAllUsers { (users, error) in
            if error != nil {
                print("FIREBASE ERROR!")
            } else {
                guard let users = users else { return print("fsdfds") }
                for fetchedUser in users {
                    if user.mutual.contains(fetchedUser.uid) { matches.append(fetchedUser) }
                }
                completion(matches, nil)
            }
        }
    }
    
    func fetchOutboundNods(for user: String, completion: @escaping (Set<String>) -> Void) {
        let outboundNodsRef = Firestore.firestore().collection("nods").whereField("author", isEqualTo: user)
        
        outboundNodsRef.getDocuments { (querySnapshot, error) in
            var outboundNods = Set<String>()
            guard let querySnapshot = querySnapshot else {
                return
            }
            if let _ = error {
                return
            }
            let documents = querySnapshot.documents
            for document in documents {
                let data = document.data()
                let nod = Nod(jsonDict: data)
                outboundNods.insert(nod.recipient)
            }
            completion(outboundNods)
        }
    }
    
    func fetchInboundNods(for user: String, completion: @escaping (Set<String>) -> Void) {
        let inboundNodsRef = Firestore.firestore().collection("nods").whereField("recipient", isEqualTo: user)
        
        inboundNodsRef.getDocuments { (querySnapshot, error) in
            var inboundNods = Set<String>()
            guard let querySnapshot = querySnapshot else {
                return
            }
            if let _ = error {
                return
            }
            let documents = querySnapshot.documents
            for document in documents {
                let data = document.data()
                let nod = Nod(jsonDict: data)
                inboundNods.insert(nod.sender)
            }
            
            completion(inboundNods)
        }
    }
    
    func sendNod(author: String, recipient: String, type: String, message: String?, completion: @escaping LHResult<Bool>) -> Void {
        let data = ["author": author, "recipient": recipient, "type": type, "message": message]
        let nodsRef = Firestore.firestore().collection("nods")
        
        nodsRef.addDocument(data: data as [String : Any]) { (error) in
            if error != nil { return completion(true, nil) }
            
            self.userSessionRepository.updateUserSession(data: [:]) { (userSession, error) in
                completion(true, nil)
            }
        }
    }
    
    func checkIfMutualNodExists(author: String, profile: String, completion: @escaping (_ result: Bool) -> Void) -> Void {
        let nodsRef = Firestore.firestore().collection("nods").whereField("author", isEqualTo: author).whereField("recipient", isEqualTo: profile)
        nodsRef.getDocuments { (querySnapshot, error) in
            guard let querySnapshot = querySnapshot else {
                return
            }
            if let _ = error {
                return
            }
            let documents = querySnapshot.documents
            for document in documents {
                let data = document.data()
                let swipe = Nod(jsonDict: data)
                if swipe.type == "like" || swipe.type == "superlike" {
                    completion(true)
                    return
                }
            }
            completion(false)
        }
    }
    
    func getInboundNotOutboundUsers(currentUser: User, completion: @escaping LHResult<[User]>) {
        var inboundNotOutboundNods: [User] = []
        userRepostitory.getAllUsers { (users, error) in
            if error != nil {
                print("FIREBASE ERROR!")
            } else {
                guard let users = users else { return print("fsdfds") }
                for fetchedUser in users {
                    if currentUser.inboundNotOutbound.contains(fetchedUser.uid) { inboundNotOutboundNods.append(fetchedUser) }
                }
                completion(inboundNotOutboundNods, nil)
            }
        }
    }
}

//        guard user.uid != nil else { return }
//        let swipesRef = Firestore.firestore().collection("swipes").whereField("author", isEqualTo: user.uid ?? "")
//        let reverseSwipesRef = Firestore.firestore().collection("swipes").whereField("swipedProfile", isEqualTo: user.uid ?? "")
//        let usersRef = Firestore.firestore().collection("users")
//
//        let userReporter = FirebaseUserReporter()
//        userReporter.userIDsBlockedOrReported(by: user) { (illegalUserIDs) in
//            swipesRef.getDocuments { (querySnapshot, error) in
//                if error != nil {
//                    return
//                }
//                guard let querySnapshot = querySnapshot else {
//                    return
//                }
//                let documents = querySnapshot.documents
//                if documents.count == 0 {
//                    completion([])
//                    return
//                }
//                let swipes = documents.map({Nod(jsonDict: $0.data())})
//                reverseSwipesRef.getDocuments(completion: { (querySnapshot, error) in
//                    if error != nil {
//                        return
//                    }
//                    guard let querySnapshot = querySnapshot else {
//                        return
//                    }
//                    let reverseDocuments = querySnapshot.documents
//                    if reverseDocuments.count == 0 {
//                        completion([])
//                        return
//                    }
//                    let reverseSwipes = reverseDocuments.map({Nod(jsonDict: $0.data())})
//                    var matchesUIDs: [String] = []
//                    // Compute all the mutual swipes
//                    for swipe in swipes {
//                        let reverseSwipeExists = reverseSwipes.contains(where: { (reverseSwipe) -> Bool in
//                            swipe.author == reverseSwipe.swipedProfile && swipe.swipedProfile == reverseSwipe.author
//                        })
//                        if reverseSwipeExists {
//                            matchesUIDs.append(swipe.swipedProfile ?? "")
//                        }
//                    }
//                    // We filter out the blocked/reported users, even if they matched
//                    matchesUIDs = matchesUIDs.filter({return !illegalUserIDs.contains($0)})
//
//                    // Now we have all the user IDs whom the current user matched, and did not block/report
//                    // We fetch their profile from the users Firebase table
//                    var matches: [User] = []
//                    var totalFetched = 0
//                    for userID in matchesUIDs {
//                        usersRef.document(userID).getDocument(completion: { (document, error) in
//                            totalFetched += 1
//                            if let document = document,
//                                let data = document.data() {
//                                let matchedProfile = User(jsonDict: data)
//                                matches.append(matchedProfile)
//                            }
//                            if (totalFetched == matchesUIDs.count) {
//                                completion(matches)
//                            }
//                        })
//                    }
//                })
//            }
//        }
//    }
//}
