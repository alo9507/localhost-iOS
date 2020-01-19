//
//  MockUserRepository.swift
//  Contact
//
//  Created by Andrew O'Brien on 11/21/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore
import CoreLocation

protocol TestResetable {
    func resetAll()
}

class MockUsersRepo: UserRepository {
    public var localUsers: [User] = []
    public var shouldFailWithError: LHError?
    
    convenience init(localUsers: [User]) {
        self.init()
        self.localUsers = localUsers
    }
    
    func deleteUser(user: User, completion: @escaping LHAuthErrorResponse) {
        completion(nil)
    }
    
    func createUser(registeringUser: User, profileImageData: Data, authSession: LHAuthSession, completion: @escaping LHResult<User>) {
        let userDict1: [String: Any] =
            ["name": "User1"
        ]
        let user1 = User(documentId: "1", dictionary: userDict1)

        completion(user1, nil)
    }
    
    var socialGraphRepository: SocialGraphRepository = MockSocialGraphRepository(userSessionRepository: MockUserSessionRepository())
    
    func updateNodInfo(with nod: Nod, completion: @escaping LHResult<User>) {
        completion(User(jsonDict: [:]), nil)
    }
    
    func getLocalAndFilteredUsers(currentUser: User, completion: @escaping LHResult<[User]>) {
        completion([], nil)
    }

    func updateCurrentUserLocation(user: User, center: CLLocationCoordinate2D, completion: @escaping LHResult<User>) {
        return
    }

    func addNewChatRoom(with newChatRoom: DocumentReference, currentUser: User, recipient: User, completion: @escaping LHResult<User>) {}

    func updateCurrentUser(userUid: String, data: Dictionary<String, Any>, completion: @escaping LHResult<User>) {
        
    }

    func getAllUsers(completion: @escaping LHResult<[User]>) {
        completion(localUsers, shouldFailWithError)
    }

    func getLocalUsers(currentUser: User, completion: @escaping LHResult<[User]>) {
        completion(localUsers, shouldFailWithError)
    }

    func getMatchedUsers(currentUser: User, completion: @escaping LHResult<[User]>) {
        let userDict1: [String: Any] =
            ["name": "User1"
        ]
        let user1 = User(documentId: "1", dictionary: userDict1)

        let userDict2: [String: Any] =
            ["name": "User2"
        ]
        let user2 = User(documentId: "1", dictionary: userDict2)

        let userDict3: [String: Any] =
            ["name": "User3"
        ]
        let user3 = User(documentId: "1", dictionary: userDict3)

        completion([user1, user2, user3], nil)
    }

    func updateUser(userUid: String, data: Dictionary<String, Any>, completion: @escaping LHResult<User>) {
        let userDict1: [String: Any] =
            ["name": "User1"
        ]
        let user1 = User(documentId: "1", dictionary: userDict1)

        completion(user1, nil)
    }

    func getUser(uid: String, completion: @escaping LHResult<User>) {
        let testUser = User(jsonDict: [:])
        testUser.firstName = "Tester"
        
        let otherUser = User(jsonDict: [:])
        otherUser.firstName = "Other"

        if (uid == "MOCK_USER_ID") {
            completion(testUser, nil)
        } else {
            completion(otherUser, nil)
        }
    }

    func getInboundNods(currentUser: User, completion: @escaping LHResult<[User]>) {
        let userDict1: [String: Any] =
            ["name": "User1"
        ]
        let user1 = User(documentId: "1", dictionary: userDict1)

        completion([user1], nil)
    }

}

extension MockUsersRepo: TestResetable {
    func resetAll() {
        localUsers = []
        shouldFailWithError = nil
    }
}
