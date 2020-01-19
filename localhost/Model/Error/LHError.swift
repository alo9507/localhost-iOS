//
//  LHError.swift
//  Contact
//
//  Created by Andrew O'Brien on 11/14/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation

public enum LHError: Error, Equatable {
    case failedToDoSomething(_ error: String)
    case illegalState(_ error: String)
    case failedToFetchLocalUsers(_ error: String)
    case firebaseError(_ error: String)
}

extension LHError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .failedToDoSomething(let error):
            return "Failed to do something: \(error)"
        case .failedToFetchLocalUsers(let error):
            return "The SpotFeedViewModel failed to fetch local users. Failed with error: \(error)"
        case .illegalState(let error):
            return "Illegal state or control flow. A result should have a value, an error or both. Received neither: \(error)"
        case .firebaseError(let error):
            return "Firebase failed with error: \(error)"
        }
    }
}
