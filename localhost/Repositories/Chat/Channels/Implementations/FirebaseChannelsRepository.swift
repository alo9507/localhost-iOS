//
//  FirebaseChannelsRepository.swift
//  Contact
//
//  Created by Andrew O'Brien on 11/17/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import FirebaseFirestore

class FirebaseChannelsRepository: ChannelsRepository {
    func listenForChannelParticipation(_ listener: (ChatChannel) -> Void) {}
    func listenForNewChannels(_ listener: (ChatChannel) -> Void) {}
    
    func fetchChannels(user: User, completion: @escaping LHResult<[ChatChannel]>) {
        let uid = user.uid
        FirebaseUserReporter().userIDsBlockedOrReported(by: user) { (illegalUserIDsSet, error) in
            if error != nil { return print(error!.localizedDescription) }
            guard let illegalUserIDsSet = illegalUserIDsSet else { return print(LHError.illegalState("Nil illegalUserIDsSet : Nil Error")) }
            
            let ref = Firestore.firestore().collection("channel_participation").whereField("user", isEqualTo: uid)
            let channelsRef = Firestore.firestore().collection("channels")
            let usersRef = Firestore.firestore().collection("users")
            ref.getDocuments { (querySnapshot, error) in
                if error != nil {
                    completion([], nil)
                    return
                }
                guard let querySnapshot = querySnapshot else { return }
                var channels: [ChatChannel] = []
                let documents = querySnapshot.documents
                if (documents.count == 0) {
                    completion([], nil)
                    return
                }
                for document in documents {
                    let data = document.data()
                    if let channelID = data["channel"] as? String {
                        channelsRef
                            .document(channelID)
                            .getDocument(completion: { (document, error) in
                                if let document = document, var channel = ChatChannel(document: document) {
                                    let otherUsers = Firestore.firestore().collection("channel_participation").whereField("channel", isEqualTo: channel.id)
                                    otherUsers.getDocuments(completion: { (snapshot, error) in
                                        guard let snapshot = snapshot else { return }
                                        let docs = snapshot.documents
                                        var participants: [User] = []
                                        if docs.count == 0 {
                                            completion([], nil)
                                            return
                                        }
                                        for doc in docs {
                                            let data = doc.data()
                                            if let userID = data["user"] as? String {
                                                usersRef
                                                    .document(userID)
                                                    .getDocument(completion: { (document, error) in
                                                        if let document = document,
                                                            let _ = document.data() {
                                                            participants.append(User(document: document)!)
                                                            if participants.count == docs.count {
                                                                channel.participants = participants
                                                                channels.append(channel)
                                                                if channels.count == documents.count {
                                                                    completion(self.sort(channels: self.filter(channels: channels, illegalUserIDsSet: illegalUserIDsSet)), nil)
                                                                }
                                                            }
                                                        }
                                                    })
                                            }
                                        }
                                    })
                                } else {
                                    completion([], nil)
                                    return
                                }
                            })
                    } else {
                        completion([], nil)
                        return
                    }
                }
            }
        }
    }
    
    func fetchChannel(user: User, channelId: String, completion: @escaping LHResult<ChatChannel>) {
        let uid = user.uid
        FirebaseUserReporter().userIDsBlockedOrReported(by: user) { (illegalUserIDsSet, error) in
            if error != nil { return print(error!.localizedDescription) }
            guard let illegalUserIDsSet = illegalUserIDsSet else { return print(LHError.illegalState("Nil illegalUserIDsSet : Nil Error")) }
            
            let ref = Firestore.firestore().collection("channel_participation").whereField("user", isEqualTo: uid)
            let channelsRef = Firestore.firestore().collection("channels")
            let usersRef = Firestore.firestore().collection("users")
            ref.getDocuments { (querySnapshot, error) in
                if error != nil {
                    completion(nil, nil)
                    return
                }
                guard let querySnapshot = querySnapshot else { return }
                var channels: [ChatChannel] = []
                let documents = querySnapshot.documents
                if (documents.count == 0) {
                    completion(nil, nil)
                    return
                }
                for document in documents {
                    let data = document.data()
                    if let channelID = data["channel"] as? String {
                        channelsRef
                            .document(channelID)
                            .getDocument(completion: { (document, error) in
                                if let document = document, var channel = ChatChannel(document: document) {
                                    let otherUsers = Firestore.firestore().collection("channel_participation").whereField("channel", isEqualTo: channel.id)
                                    otherUsers.getDocuments(completion: { (snapshot, error) in
                                        guard let snapshot = snapshot else { return }
                                        let docs = snapshot.documents
                                        var participants: [User] = []
                                        if docs.count == 0 {
                                            completion(nil, nil)
                                            return
                                        }
                                        for doc in docs {
                                            let data = doc.data()
                                            if let userID = data["user"] as? String {
                                                usersRef
                                                    .document(userID)
                                                    .getDocument(completion: { (document, error) in
                                                        if let document = document,
                                                            let _ = document.data() {
                                                            participants.append(User(document: document)!)
                                                            if participants.count == docs.count {
                                                                channel.participants = participants
                                                                channels.append(channel)
                                                                if channels.count == documents.count {
                                                                    let prechannels = self.sort(channels: self.filter(channels: channels, illegalUserIDsSet: illegalUserIDsSet))
                                                                    let channel: ChatChannel? = prechannels.filter { (channel) -> Bool in
                                                                        return channel.id == channelId
                                                                    }.first
                                                                    completion(channel, nil)
                                                                }
                                                            }
                                                        }
                                                    })
                                            }
                                        }
                                    })
                                } else {
                                    completion(nil, nil)
                                    return
                                }
                            })
                    } else {
                        completion(nil, nil)
                        return
                    }
                }
            }
        }
    }
    
    func createChannel(creator: User, friends: [User], completion: @escaping LHResult<ChatChannel>) {
        let uid = creator.uid
        let channelParticipationRef = Firestore.firestore().collection("channel_participation")
        let channelsRef = Firestore.firestore().collection("channels")
        
        let newChannelRef = channelsRef.document()
        let channelDict: [String: Any] = [
            "lastMessage": "No message",
            "name": "New Group",
            "creator_id": uid,
            "channelID": newChannelRef.documentID
        ]
        newChannelRef.setData(channelDict)
        
        let allFriends = [creator] + Array(friends)
        var count = 0
        allFriends.forEach { (friend) in
            let doc: [String: Any] = [
                "channel": newChannelRef.documentID,
                "user": friend.uid
            ]
            channelParticipationRef.addDocument(data: doc, completion: { (error) in
                count += 1
                if count == allFriends.count {
                    newChannelRef.getDocument(completion: { (snapshot, error) in
                        guard let snapshot = snapshot else { return }
                        completion(ChatChannel(document: snapshot), nil)
                    })
                }
            })
        }
    }
    
    func renameGroup(channel: ChatChannel, name: String) {
        let data: [String : Any] = [
            "name": name
        ]
        Firestore.firestore().collection("channels").document(channel.id).setData(data, merge: true)
    }
    
    func leaveGroup(channel: ChatChannel, user: User) {
        let uid = user.uid
        let ref = Firestore.firestore().collection("channel_participation").whereField("user", isEqualTo: uid).whereField("channel", isEqualTo: channel.id)
        ref.getDocuments { (snapshot, error) in
            if let snapshot = snapshot {
                snapshot.documents.forEach({ (document) in
                    Firestore.firestore().collection("channel_participation").document(document.documentID).delete()
                })
            }
        }
    }
    
    
    func updateChannelParticipationIfNeeded(channel: ChatChannel) {
        if channel.participants.count != 2 {
            return
        }
        guard let uid1 = channel.participants.first?.uid else { return print("no user 1") }
        let uid2 = channel.participants[1].uid
        
        self.updateChannelParticipationIfNeeded(channel: channel, uID: uid1)
        self.updateChannelParticipationIfNeeded(channel: channel, uID: uid2)
    }
    
    func updateChannelParticipationIfNeeded(channel: ChatChannel, uID: String) {
        let ref1 = Firestore.firestore().collection("channel_participation").whereField("user", isEqualTo: uID).whereField("channel", isEqualTo: channel.id)
        ref1.getDocuments { (querySnapshot, error) in
            if (querySnapshot?.documents.count == 0) {
                let data: [String: Any] = [
                    "user": uID,
                    "channel": channel.id
                ]
                Firestore.firestore().collection("channel_participation").addDocument(data: data, completion: nil)
            }
        }
    }
    func sort(channels: [ChatChannel]) -> [ChatChannel] {
        return channels.sorted(by: {$0.lastMessageDate > $1.lastMessageDate})
    }
    
    func filter(channels: [ChatChannel], illegalUserIDsSet: Set<String>) -> [ChatChannel] {
        var validChannels: [ChatChannel] = []
        channels.forEach { (channel) in
            if !channel.participants.contains(where: { (user) -> Bool in
                return illegalUserIDsSet.contains(user.uid)
            }) {
                validChannels.append(channel)
            }
        }
        return validChannels
    }
}
