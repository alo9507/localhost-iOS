//
//  FileUserSessionDataStore.swift
//  Contact
//
//  Created by Andrew O'Brien on 8/20/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//
import Foundation

public class FileUserSessionDataStore: UserSessionDataStore {
    // MARK: - Properties
    var docsURL: URL? {
        return FileManager
            .default.urls(for: FileManager.SearchPathDirectory.documentDirectory,
                          in: FileManager.SearchPathDomainMask.allDomainsMask).first
    }
    
    // MARK: - Methods
    public init() {}
    
    public func readUserSession(completion: @escaping LHResult<UserSession>) {
        guard let docsURL = docsURL else {
            return completion(nil, LHError.failedToDoSomething("readUserSession failed to get docsUrl"))
        }
        guard let jsonData = try? Data(contentsOf: docsURL.appendingPathComponent("user_session.json")) else {
            completion(nil, nil)
            return
        }
        let decoder = JSONDecoder()
        
        do {
           let userSession = try decoder.decode(UserSession.self, from: jsonData)
           completion(userSession, nil)
        } catch let DecodingError.dataCorrupted(context) {
            print("❌❌❌ERROR DECODING USER SESSION FROM FILESYSTEM!❌❌❌")
            print(context)
            completion(nil, nil)
        } catch let DecodingError.keyNotFound(key, context) {
            print("❌❌❌ERROR DECODING USER SESSION FROM FILESYSTEM!❌❌❌")
            print("Key '\(key)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
            completion(nil, nil)
        } catch let DecodingError.valueNotFound(value, context) {
            print("❌❌❌ERROR DECODING USER SESSION FROM FILESYSTEM!❌❌❌")
            print("Value '\(value)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
            completion(nil, nil)
        } catch let DecodingError.typeMismatch(type, context)  {
            print("❌❌❌ERROR DECODING USER SESSION FROM FILESYSTEM!❌❌❌")
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("codingPath:", context.codingPath)
            completion(nil, nil)
        } catch {
            print("❌❌❌ERROR DECODING USER SESSION FROM FILESYSTEM!❌❌❌")
            print("error: ", error)
            completion(nil, nil)
        }
    }
    
    public func save(userSession: UserSession, completion: @escaping LHResult<UserSession>) {
        let encoder = JSONEncoder()
        let jsonData = try! encoder.encode(userSession)
        
        guard let docsURL = docsURL else {
            return completion(nil, LHError.failedToDoSomething("readUserSession failed to get docsUrl"))
        }
        try? jsonData.write(to: docsURL.appendingPathComponent("user_session.json"))
        completion(userSession, nil)
    }
    
    public func delete(completion: @escaping LHResult<String>) {
        guard let docsURL = docsURL else {
            return completion(nil, LHError.failedToDoSomething("delete failed to get docsUrl"))
        }
        do {
            try FileManager.default.removeItem(at: docsURL.appendingPathComponent("user_session.json"))
        } catch {
            return completion(nil, LHError.failedToDoSomething("delete failed to decrypt"))
        }
        completion("Successfully deleted from cache", nil)
    }
}
