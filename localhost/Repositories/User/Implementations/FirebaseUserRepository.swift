//
//  FirebaseUserRepository.swift
//  Contact
//
//  Created by Andrew O'Brien on 11/21/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAuth
import GeoFire

class FirestoreUserRepository: UserRepository {
    var socialGraphRepository: SocialGraphRepository = MockSocialGraphRepository(userSessionRepository: MockUserSessionRepository())
    
    func deleteUser(user: User, completion: @escaping LHAuthErrorResponse) {
        let userRef = FirestoreDataService.instance.REF_USERS.document(user.uid)
        
        guard let currentUser = Auth.auth().currentUser else {
            return print("❌ Failed to delete current user account because no user is logged in!")
        }
        
        currentUser.delete(completion: { (error) in
            if error != nil {
                let nsError = error as! NSError
                switch nsError.userInfo["error_name"] as? String {
                case "ERROR_REQUIRES_RECENT_LOGIN":
                    completion(LHAuthError.credentialsRequiredToDeleteAccount(error!.localizedDescription))
                default:
                    fatalError(error!.localizedDescription)
                }
            } else {
                print("👍🏻 Successfully deleted user account: \(String(describing: currentUser.email))")
                print("💨 Deleting user information from database...")
                userRef.delete { (error) in
                    if error != nil {
                        completion(LHAuthError.failedToDeleteAccount(error!.localizedDescription))
                    } else {
                        print("👍🏻 Successfully deleted user from database")
                        completion(nil)
                    }
                }
            }
        })
    }
    
    // MARK: CREATE
    
    func createUser(registeringUser: User, profileImageData: Data, authSession: LHAuthSession, completion: @escaping LHResult<User>) {
        let profileImageData = profileImageData
        
        registeringUser.uid = authSession.uid
        registeringUser.showMy = [
            "Name",
            "Age",
            "Education",
            "Affiliations",
            "Sex",
            "Profile Picture",
            "Conversation Topics",
            "Skills",
            "Sexual Preference",
            "Hometown",
            "Marital Status"
        ]
        
        registeringUser.visibilitySettings
        = VisibilitySettings(sex: .all,
                             sexualOrientation: .all,
                             lowerAgeBound: 0,
                             upperAgeBound: 100,
                             testSetting: .eclecticCafe,
                             blockedUsers: [],
                             blockedBy: []
                            )
        
        FirestoreDataService.instance.STORAGE.child(authSession.uid).putData(profileImageData, metadata: nil, completion: { (metadata, error) in
            if error != nil {
                completion(nil, LHError.failedToDoSomething("Firebase to store profile image: \(error!)"))
            }
            
            FirestoreDataService.instance.STORAGE.child((metadata?.name)!).downloadURL(completion: { (url, error) in
                if error != nil {
                    print(error!)
                } else {
                    registeringUser.profileImageUrl = url!.absoluteURL.absoluteString
                    registeringUser.loadUsersFrom = "eclecticCafe"
                    registeringUser.testLocation = "eclecticCafe"
                    registeringUser.visibilitySettings =
                        VisibilitySettings(
                            sex: .all,
                            sexualOrientation: .all,
                            lowerAgeBound: 0,
                            upperAgeBound: 100,
                            testSetting: .eclecticCafe,
                            blockedUsers: [],
                            blockedBy: []
                    )
                    FirestoreDataService.instance.REF_USERS.document(registeringUser.uid).setData(registeringUser.documentData) { (error) in
                        if error != nil {
                            completion(nil, LHError.failedToDoSomething("Firebase to set data on created user: \(error!)"))
                        } else {
                            completion(registeringUser, nil)
                        }
                    }
                }
            })
        })
    }
    
    // MARK: READ
    func getUser(uid: String, completion: @escaping LHResult<User>) {
        let userRef = FirestoreDataService.instance.REF_USERS.document(uid)
        
        userRef.getDocument { (documentSnapshot, error) in
            if error != nil { return completion(nil, LHError.failedToDoSomething("Failed to get document: \(error!)")) }
            guard let documentSnapshot = documentSnapshot else { return completion(nil, LHError.illegalState("No errors and no do snapshot")) }
            
            guard let user = User(document: documentSnapshot) else {
                return completion(nil, LHError.failedToDoSomething("Failed to initialize user from document data: \(error!)"))
            }
            
            self.socialGraphRepository.fetchInboundNods(for: uid) { (inboundNods) in
                user.inbound = inboundNods
                self.socialGraphRepository.fetchOutboundNods(for: uid, completion: { (outboundNods) in
                    user.outbound = outboundNods
                    completion(user, nil)
                })
            }
        }
    }
    
    func getAllUsers(completion: @escaping LHResult<[User]>) {
        FirestoreDataService.instance.REF_USERS.getDocuments { (querySnapshot, error) in
            var users: [User] = []
            if error != nil {
                completion(nil, LHError.failedToDoSomething("Failed to get allUsers: \(error!)"))
            } else {
                for documentSnapshot in querySnapshot!.documents {
                    let user = User(document: documentSnapshot)
                    
                    self.getUser(uid: user!.uid) { (user, error) in
                        users.append(user!)
                        completion(users, nil)
                    }
                }
            }
        }
    }
    
    static func getAllUsers(completion: @escaping LHResult<[User]>) {
        FirestoreDataService.instance.REF_USERS.getDocuments { (querySnapshot, error) in
            var users: [User] = []
            if error != nil {
                completion(nil, LHError.failedToDoSomething("Failed to get allUsers: \(error!)"))
            } else {
                for documentSnapshot in querySnapshot!.documents {
                    let user = User(document: documentSnapshot)
                    users.append(user!)
                }
            }
            completion(users, nil)
        }
    }
    
    func getLocalUsers(currentUser: User, completion: @escaping LHResult<[User]>) {
        guard let queries = GFGeoHashQuery.queries(forLocation: currentUser.location.location, radius: 500000) else {
            return completion(nil, LHError.failedToDoSomething("Failed to getLocalUsers. Convert query failed"))
        }
        
        for query in queries {
            guard let query = query as? GFGeoHashQuery else {
                continue
            }
            
            convert(query).getDocuments { (snapshot, error) in
                guard let documents = snapshot?.documents, error == nil else {
                    return completion(nil, LHError.failedToDoSomething("Geohash query failed"))
                }
                let allLocalUsers = documents.compactMap { User(document: $0) }
                completion(allLocalUsers, nil)
            }
        }
    }
    
    func getLocalAndFilteredUsers(currentUser: User, completion: @escaping LHResult<[User]>) {
        guard let queries = GFGeoHashQuery.queries(forLocation: currentUser.location.location, radius: 500000) else {
            return completion(nil, LHError.failedToDoSomething("Failed to getLocalUsers. Convert query failed"))
        }
        
        for query in queries {
            guard let query = query as? GFGeoHashQuery else {
                continue
            }
            
            convert(query).getDocuments { (snapshot, error) in
                guard let documents = snapshot?.documents, error == nil else {
                    return completion(nil, LHError.failedToDoSomething("Geohash query failed"))
                }
                let allLocalUsers = documents.compactMap { User(document: $0) }
                
                let filteredLocalUsers = allLocalUsers
                    .filter({ (user) -> Bool in
                        currentUser.visibilitySettings.filter(currentUser, user, filters: [
                            .isNotCurrentUser,
                            .isVisible,
                            .isInAgeRange
                        ])
                    })
                
                completion(filteredLocalUsers, nil)
            }
        }
    }
    
    // MARK: UPDATE
    func updateUser(userUid: String, data: Dictionary<String, Any>, completion: @escaping LHResult<User>) {
        let userDocRef = FirestoreDataService.instance.REF_USERS.document(userUid)
        
        userDocRef.updateData(data) { (error) in
            if error != nil { return completion(nil, LHError.firebaseError("Failed to updateUser: \(error!)")) }
            completion(UserSessionStore.user, nil)
        }
    }
}

extension FirestoreUserRepository {
    func convert(_ query: GFGeoHashQuery) -> Query {
        return FirestoreDataService.instance.REF_USERS.order(by: "geohash")
            .whereField("geohash", isGreaterThan: query.startValue as Any)
            .whereField("geohash", isLessThan: query.endValue as Any)
    }
}
