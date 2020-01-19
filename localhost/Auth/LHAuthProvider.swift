//
//  AuthProvider.swift
//  AuthFramework
//
//  Created by Andrew O'Brien on 12/11/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//
public enum LHAuthProvider {
    case firebase
    
    var remoteProvider: RemoteAuthProvider {
        switch self {
        case .firebase:
            return FirebaseRemoteAuthProvider()
        }
    }
}
