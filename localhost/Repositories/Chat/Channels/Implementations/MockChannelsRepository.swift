//
//  MockChannelsRepository.swift
//  Contact
//
//  Created by Andrew O'Brien on 1/1/20.
//  Copyright © 2020 Andrew O'Brien. All rights reserved.
//

import Foundation

class MockChannelsRepository: ChannelsRepository {
    func listenForChannelParticipation(_ listener: (ChatChannel) -> Void) {}
    func listenForNewChannels(_ listener: (ChatChannel) -> Void) {}
    
    func fetchChannels(user: User, completion: @escaping LHResult<[ChatChannel]>) {
        completion([], nil)
    }
    
    func fetchChannel(user: User, channelId: String, completion: @escaping LHResult<ChatChannel>) {
        completion(nil, nil)
    }
    
    func createChannel(creator: User, friends: [User], completion: @escaping LHResult<ChatChannel>) {
        completion(nil, nil)
    }
    
    func renameGroup(channel: ChatChannel, name: String) {
        
    }
    
    func leaveGroup(channel: ChatChannel, user: User) {
        
    }
    
    func updateChannelParticipationIfNeeded(channel: ChatChannel) {
        
    }
    
    func updateChannelParticipationIfNeeded(channel: ChatChannel, uID: String) {
        
    }
    
    func sort(channels: [ChatChannel]) -> [ChatChannel] {
        return []
    }
    
    func filter(channels: [ChatChannel], illegalUserIDsSet: Set<String>) -> [ChatChannel] {
        return []
    }
    
    
}
