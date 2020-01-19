////
////  KeychainUserSessionDataStore.swift
////  Contact
////
////  Created by Andrew O'Brien on 8/20/19.
////  Copyright © 2019 Andrew O'Brien. All rights reserved.
////
//
//import Foundation
//import PromiseKit
//
//public class KeychainUserSessionDataStore: UserSessionDataStore {
//    
//    // MARK: - Properties
//    let userSessionCoder: UserSessionCoding
//    
//    // MARK: - Methods
//    public init(userSessionCoder: UserSessionCoding) {
//        self.userSessionCoder = userSessionCoder
//    }
//    
//    public func readUserSession(completion: @escaping (Result<UserSession?>) -> Void) {
//        DispatchQueue.global().async {
//            self.readUserSessionSync(completion: completion)
//        }
//    }
//    
//    public func save(userSession: UserSession) -> Promise<(UserSession)> {
//        let data = userSessionCoder.encode(userSession: userSession)
//        let item = KeychainItemWithData(data: data)
//        return self.readUserSession()
//            .map { userSessionFromKeychain -> UserSession in
//                if userSessionFromKeychain == nil {
//                    try Keychain.save(item: item)
//                } else {
//                    try Keychain.update(item: item)
//                }
//                return userSession
//        }
//    }
//    
//    public func delete(userSession: UserSession) -> Promise<(UserSession)> {
//        return Promise<UserSession> { seal in
//            DispatchQueue.global().async {
//                self.deleteSync(userSession: userSession, seal: seal)
//            }
//        }
//    }
//}
//
//extension KeychainUserSessionDataStore {
//    
//    func readUserSessionSync(completion: @escaping (Result<UserSession?>) -> Void) {
//        do {
//            let query = KeychainItemQuery()
//            if let data = try Keychain.findItem(query: query) {
//                let userSession = self.userSessionCoder.decode(data: data)
//                completion(.value(userSession))
//            } else {
//                completion(.value(nil))
//            }
//        } catch {
//            completion(.error(error))
//        }
//    }
//    
//    func deleteSync(userSession: UserSession, seal: Resolver<UserSession>) {
//        do {
//            let item = KeychainItem()
//            try Keychain.delete(item: item)
//            seal.fulfill(userSession)
//        } catch {
//            seal.reject(error)
//        }
//    }
//}
//
//enum KeychainUserSessionDataStoreError: Error {
//    case typeCast
//    case unknown
//}
