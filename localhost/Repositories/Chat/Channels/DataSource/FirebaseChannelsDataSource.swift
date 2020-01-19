//
//  FirebaseChannelsDataSource.swift
//  ChatApp
//
//  Created by Florian Marcu on 9/15/18.
//  Copyright © 2018 Instamobile. All rights reserved.
//

import FirebaseFirestore
import UIKit

class FirebaseChannelsDataSource: GenericCollectionViewControllerDataSource {
    weak var delegate: GenericCollectionViewControllerDataSourceDelegate?

    var channels: [ChatChannel] = []
    var user: User? = nil
    var participationListener: ListenerRegistration? = nil
    var channelListener: ListenerRegistration? = nil
    var isLoading: Bool = false

    var channelsRepository: ChannelsRepository
    
    init(channelsRepository: ChannelsRepository) {
        self.channelsRepository = channelsRepository
    }
    
    deinit {
        participationListener?.remove()
        channelListener?.remove()
    }

    func object(at index: Int) -> GenericBaseModel? {
        if index < channels.count {
            return channels[index]
        }
        return nil
    }

    func numberOfObjects() -> Int {
        return channels.count
    }

    func loadFirst() {
        participationListener = Firestore.firestore().collection("channel_participation").addSnapshotListener({[weak self] (querySnapshot, error) in
            guard let strongSelf = self else { return }
            guard let snapshot = querySnapshot else {
                print("Error listening for channel participation updates: \(error?.localizedDescription ?? "No error")")
                return
            }

            snapshot.documentChanges.forEach { change in
                let data = change.document.data()
                if data["user"] as? String == strongSelf.user?.uid {
                    strongSelf.loadIfNeeded()
                }
            }
        })

        channelListener = Firestore.firestore().collection("channels").addSnapshotListener({[weak self] (querySnapshot, error) in
            guard let strongSelf = self else { return }
            guard querySnapshot != nil else {
                print("Error listening for channel participation updates: \(error?.localizedDescription ?? "No error")")
                return
            }
            guard (strongSelf.user?.uid) != nil else { return }
            strongSelf.loadIfNeeded()
        })
        loadIfNeeded()
    }

    func loadBottom() {}
    func loadTop() {}

    fileprivate func loadIfNeeded() {
        guard let user = user else {
            self.channels = []
            self.delegate?.genericCollectionViewControllerDataSource(self, didLoadFirst: channels)
            return
        }
        if isLoading == true {
            return
        }
        isLoading = true
        channelsRepository.fetchChannels(user: user) {[weak self] (channels, error) in
            if error != nil { return print(error!.localizedDescription) }
            guard let channels = channels else { return print(LHError.illegalState("Nil channels : Nil Error")) }
            
            guard let strongSelf = self else { return }
            strongSelf.channels = channels
            strongSelf.isLoading = false
            strongSelf.delegate?.genericCollectionViewControllerDataSource(strongSelf, didLoadFirst: channels)
        }
    }
}
