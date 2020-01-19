//
//  LHAuthError.swift
//  AuthFramework
//
//  Created by Andrew O'Brien on 12/18/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation

public enum LHAuthError: Error, Equatable {
    case failedToReadLocalAuthSession(_ error: String)
    case failedToPersistUserSessionData(_ error: String)
    case failedToSignInWithRemote(_ error: String)
    case failedToSignOutWithRemote(_ error: String)
    case failedToRemoveUserSessionData(_ error: String)
    case failedToRetrieveAuthSession(_ error: String)
    case wrongEmail(_ error: String)
    case wrongPassword(_ error: String)
    case failedToRetrieveRefreshToken(_ error: String)
    case failedToValidateAuthSession(_ error: String)
    case invalidAccessToken(_ error: String)
    case cannotSignOutIfNotSignedIn
    case invalidGroup(_ error: String)
    case failedToSignUpNewUser(_ error: String)
    case failedToDeleteAccount(_ error: String)
    case credentialsRequiredToDeleteAccount(_ error: String)
    case unknownError(_ error: String)
}

extension LHAuthError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .failedToReadLocalAuthSession(let error):
            return "Failed to read locally persisted : \(error)auth session: \(error)"
        case .failedToPersistUserSessionData(let error):
            return "Error!: \(error)"
        case .failedToSignInWithRemote(let error):
            return "failedToSignInWithRemote: \(error)"
        case .failedToSignOutWithRemote(let error):
            return "Error!: \(error)"
        case .failedToRemoveUserSessionData(let error):
            return "Error!: \(error)"
        case .wrongEmail(let error):
            return "Error!: \(error)"
        case .wrongPassword(let error):
            return "Error!: \(error)"
        case .failedToRetrieveRefreshToken(let error):
            return "Error!: \(error)"
        case .failedToValidateAuthSession(let error):
            return "Error!: \(error)"
        case .invalidAccessToken(let error):
            return "Error!: \(error)"
        case .cannotSignOutIfNotSignedIn:
            return "cannotSignOutIfNotSignedIn"
        case .invalidGroup(let error):
            return "Error!: \(error)"
        case .failedToSignUpNewUser(let error):
            return "Error! \(error)"
        case .failedToRetrieveAuthSession(let error):
            return "FailedToRetrieveAuthSession: \(error)"
        case .credentialsRequiredToDeleteAccount(let error):
            return "credentialsRequiredToDeleteAccount: \(error)"
        case .failedToDeleteAccount(let error):
            return "failedToDeleteAccount: \(error)"
        case .unknownError(let error):
            return "UnknownError: \(error)"
        }
    }
}
