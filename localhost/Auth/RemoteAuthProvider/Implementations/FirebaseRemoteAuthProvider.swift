//
//  FirebaseRemoteAuthProvider.swift
//  AuthFramework
//
//  Created by Andrew O'Brien on 1/2/20.
//  Copyright © 2020 Andrew O'Brien. All rights reserved.
//

import Foundation
import FirebaseAuth
import Firebase

class FirebaseRemoteAuthProvider: RemoteAuthProvider {
    func signIn(email: String?, password: String?, phoneNumber: String?, _ completion: @escaping LHAuthResponse) {
        guard let email = email, let password = password else {
            fatalError()
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (firestoreAuthResult, error) in
            if error != nil {
                var authError: LHAuthError
                let nsError = error! as NSError
                switch nsError.userInfo["error_name"] as? String {
                case "ERROR_WRONG_PASSWORD":
                    authError = LHAuthError.wrongPassword(nsError.localizedDescription)
                case "ERROR_INVALID_EMAIL":
                    authError = LHAuthError.wrongEmail(nsError.localizedDescription)
                default:
                    authError = LHAuthError.unknownError("\(nsError.localizedDescription)")
                }
                
                completion(nil, authError)
            }
            guard let firestoreAuthResult = firestoreAuthResult else { return completion(nil, LHAuthError.unknownError("Firebase successfully authenticated but gave no result?")) }
            let authSession = LHAuthSession(token: "FAKE_REMOTE_TOKEN", refreshToken: "FAKE_REFRESH_TOKEN", uid: firestoreAuthResult.user.uid)
            completion(authSession, nil)
        }
    }
    
    func signOut(authSession: LHAuthSession, _ completion: @escaping LHAuthErrorResponse) {
        do {
            try Auth.auth().signOut()
            completion(nil)
        } catch (let error) {
            completion(LHAuthError.failedToSignOutWithRemote(error.localizedDescription))
        }
    }
    
    func isValidAuthSession(authSession: LHAuthSession, _ completion: @escaping LHAuthValidationResponse) {
        completion(true, nil)
    }
    
    func signUp(email: String, password: String, completion: @escaping LHAuthResponse) {
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if error != nil { return completion(nil, LHAuthError.failedToSignUpNewUser("Failed to even create user: \(error!.localizedDescription)")) }
            guard let authResult = authResult else { return completion(nil, LHAuthError.failedToSignUpNewUser("No AuthResult Returned, but also no errors")) }
            let authSession = LHAuthSession(token: "FAKE_AUTH_TOKEN", refreshToken: "FAKE_REFRESH_TOKEN", uid: authResult.user.uid)
            completion(authSession, nil)
        }
    }
}
