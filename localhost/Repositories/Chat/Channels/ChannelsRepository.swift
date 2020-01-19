//
//  ChannelsRepository.swift
//  Contact
//
//  Created by Andrew O'Brien on 12/16/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation

protocol ChannelsRepository {
    func fetchChannels(user: User, completion: @escaping LHResult<[ChatChannel]>)
    func fetchChannel(user: User, channelId: String, completion: @escaping LHResult<ChatChannel>)
    func createChannel(creator: User, friends: [User], completion: @escaping LHResult<ChatChannel>)
    
    func listenForChannelParticipation(_ listener: (ChatChannel) -> Void)
    func listenForNewChannels(_ listener: (ChatChannel) -> Void)
    
    func renameGroup(channel: ChatChannel, name: String)
    func leaveGroup(channel: ChatChannel, user: User)
    func updateChannelParticipationIfNeeded(channel: ChatChannel)
    func updateChannelParticipationIfNeeded(channel: ChatChannel, uID: String)
    func sort(channels: [ChatChannel]) -> [ChatChannel]
    func filter(channels: [ChatChannel], illegalUserIDsSet: Set<String>) -> [ChatChannel]
}
