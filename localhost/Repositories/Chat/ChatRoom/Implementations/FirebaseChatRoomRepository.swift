//
//  ChatRoomRepository.swift
//  Contact
//
//  Created by Andrew O'Brien on 12/16/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseStorage

class FirebaseChatRoomRepository: ChatRoomRepository {
    static func subscribeToMessages(channel: ChatChannel, completion: @escaping LHResult<DocumentChange>) {
        let reference = DB_BASE.collection(["channels", channel.id, "thread"].joined(separator: "/"))
        
        let _ = reference.addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error listening for channel updates: \(error?.localizedDescription ?? "No error")")
                return
            }

            snapshot.documentChanges.forEach { change in
                completion(change, nil)
            }
        }
    }
    
    static func sendMessage(channel: ChatChannel, message: ChatMessage, completion: @escaping LHResult<ChatMessage>) {
        let reference = DB_BASE.collection(["channels", channel.id, "thread"].joined(separator: "/"))
        
        reference.addDocument(data: message.representation) {error in
            if let e = error {
                print("Error sending message: \(e.localizedDescription)")
                return
            }

            let channelRef = DB_BASE.collection("channels").document(channel.id)
            var lastMessage = ""
            switch message.kind {
            case let .text(text):
                lastMessage = text
            case .photo(_):
                lastMessage = "Someone sent a photo."
            default:
                break
            }
            let newData: [String: Any] = [
                "lastMessageDate": Date(),
                "lastMessage": lastMessage
            ]
            channelRef.setData(newData, merge: true)
            completion(message, nil)
        }
    }
    
    static func uploadImage(_ image: UIImage, to channel: ChatChannel, completion: @escaping (URL?) -> Void) {

        guard let scaledImage = image.scaledToSafeUploadSize, let data = scaledImage.jpegData(compressionQuality: 0.4) else {
            completion(nil)
            return
        }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        let imageName = [UUID().uuidString, String(Date().timeIntervalSince1970)].joined()
        
        FirestoreDataService.instance.STORAGE.child(channel.id).child(imageName).putData(data, metadata: metadata) { meta, error in
            
            if let name = meta?.path, let bucket = meta?.bucket {
                let path = "gs://" + bucket + "/" + name
                completion(URL(string: path))
            } else {
                completion(nil)
            }
        }
    }
    
    func updateCurrentUserIsTyping(currentUser: User, recipient: User, completion: @escaping LHResult<Bool>) {
        return
    }
    
    func listenForTyping(currentUser: User, recipient: User, completion: @escaping LHResult<Bool>) {
        return
    }
}
