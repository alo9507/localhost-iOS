//
//  FileUserSessionRepository.swift
//  Contact
//
//  Created by Andrew O'Brien on 8/21/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation
import PromiseKit

public class FileUserSessionDataStore: UserSessionDataStore {
    
    // MARK: - Properties
    var docsURL: URL? {
        return FileManager
            .default.urls(for: FileManager.SearchPathDirectory.documentDirectory,
                          in: FileManager.SearchPathDomainMask.allDomainsMask).first
    }
    
    // MARK: - Methods
    public init() {}
    
    public func readUserSession() -> Promise<UserSession?> {
        return Promise() { seal in
            guard let docsURL = docsURL else {
                seal.reject(KooberKitError.any)
                return
            }
            guard let jsonData = try? Data(contentsOf: docsURL.appendingPathComponent("user_session.json")) else {
                seal.fulfill(nil)
                return
            }
            let decoder = JSONDecoder()
            let userSession = try! decoder.decode(UserSession.self, from: jsonData)
            seal.fulfill(userSession)
        }
    }
    
    public func save(userSession: UserSession) -> Promise<(UserSession)> {
        return Promise() { seal in
            let encoder = JSONEncoder()
            let jsonData = try! encoder.encode(userSession)
            
            guard let docsURL = docsURL else {
                seal.reject(KooberKitError.any)
                return
            }
            try? jsonData.write(to: docsURL.appendingPathComponent("user_session.json"))
            seal.fulfill(userSession)
        }
    }
    
    public func delete(userSession: UserSession) -> Promise<(UserSession)> {
        return Promise() { seal in
            guard let docsURL = docsURL else {
                seal.reject(KooberKitError.any)
                return
            }
            do {
                try FileManager.default.removeItem(at: docsURL.appendingPathComponent("user_session.json"))
            } catch {
                seal.reject(KooberKitError.any)
                return
            }
            seal.fulfill(userSession)
        }
    }
}

