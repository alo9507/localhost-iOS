//
//  FirebaseUserReporter.swift
//  Contact
//
//  Created by Andrew O'Brien on 11/17/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import FirebaseFirestore
import UIKit

class FirebaseUserReporter: UserReporter {
    func report(sourceUser: User, destUser: User, reason: ReportingReason, completion: @escaping LHResult<Bool>) {
        let sourceID = sourceUser.uid
        let destID = destUser.uid
        let reportsRef = Firestore.firestore().collection("reports")
        let data: [String: Any] = [
            "source": sourceID,
            "dest": destID,
            "reason": reason.rawValue,
            "createdAt": Date()
        ]
        reportsRef.addDocument(data: data) { (error) in
            if error == nil {
                NotificationCenter.default.post(name: kUserReportingDidUpdateNotificationName, object: nil)
            }
            completion(error == nil, nil)
        }
    }

    func block(sourceUser: User, destUser: User, completion: @escaping LHResult<Bool>) {
        let sourceID = sourceUser.uid
        let destID = destUser.uid
        let blockRef = Firestore.firestore().collection("blocks")
        let data: [String: Any] = [
            "source": sourceID,
            "dest": destID,
            "createdAt": Date()
        ]
        blockRef.addDocument(data: data) { (error) in
            if error == nil {
                NotificationCenter.default.post(name: kUserReportingDidUpdateNotificationName, object: nil)
            }
            completion(error == nil, nil)
        }
    }

    func userIDsBlockedOrReported(by user: User, completion: @escaping LHResult<Set<String>>) {
        let id = user.uid
        let blocksRef: Query = Firestore.firestore().collection("blocks").whereField("source", isEqualTo: id)
        blocksRef.getDocuments {(querySnapshot, error) in
            if error != nil {
                completion(Set<String>(), nil)
                return
            }
            guard let querySnapshot = querySnapshot else {
                completion(Set<String>(), nil)
                return
            }
            var blockedIDs: [String] = []
            let documents = querySnapshot.documents
            for document in documents {
                if let dest = document.data()["dest"] as? String {
                    blockedIDs.append(dest)
                }
            }
            let reportsRef: Query = Firestore.firestore().collection("reports").whereField("source", isEqualTo: id)
            reportsRef.getDocuments {(querySnapshot, error) in
                if error != nil {
                    completion(Set<String>(blockedIDs), nil)
                    return
                }
                guard let querySnapshot = querySnapshot else {
                    completion(Set<String>(blockedIDs), nil)
                    return
                }
                var reportedIDs: [String] = []
                let documents = querySnapshot.documents
                for document in documents {
                    if let dest = document.data()["dest"] as? String {
                        reportedIDs.append(dest)
                    }
                }
                completion(Set<String>(blockedIDs + reportedIDs), nil)
            }
        }
    }
}
