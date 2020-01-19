//
//  MockChatRoomRepository.swift
//  Contact
//
//  Created by Andrew O'Brien on 11/21/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

class MockChatRoomRepository: ChatRoomRepository {
    static func uploadImage(_ image: UIImage, to channel: ChatChannel, completion: @escaping (URL?) -> Void) {
        
    }
    
    static func subscribeToMessages(channel: ChatChannel, completion: @escaping LHResult<DocumentChange>) {
        
    }
    
    static func sendMessage(channel: ChatChannel, message: ChatMessage, completion: @escaping LHResult<ChatMessage>) {
        
    }
    
    func loadChatRooms(currentUser: User, completion: @escaping LHResult<[ChatChannel]>) {}
    static func createNewChatRoom(currentUser: User, recipient: User, completion: @escaping LHResult<String>) {}
    func listenForTyping(currentUser: User, recipient: User, completion: @escaping LHResult<Bool>) {}
    func updateCurrentUserIsTyping(currentUser: User, recipient: User, completion: @escaping LHResult<Bool>) {}
}
