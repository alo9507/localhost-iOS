//
//  ChatRoomsCoordinator.swift
//  Contact
//
//  Created by Andrew O'Brien on 12/3/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation
import UIKit

class ChatRoomsHomeCoordinator: Coordinator {
    
    private let navigationController: UINavigationController
    private let chatRoomsHomeViewController: ChatRoomsHomeViewController
    
    lazy var user: User = UserSessionStore.shared.userSession.user
    lazy var uiConfig: UIGenericConfigurationProtocol? = nil
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.chatRoomsHomeViewController = (navigationController.viewControllers[0] as! YourCircleViewController).chatRoomsHomeViewController
    }
    
    override func start() {
        let user = UserSessionStore.shared.userSession.user
        self.uiConfig = chatRoomsHomeViewController.uiConfig
        
        let chatRoomsVC = AppDelegate.appContainer.makeChatRoomsViewController(
            uiConfig: chatRoomsHomeViewController.uiConfig,
            matchesDataSource: chatRoomsHomeViewController.matchesDataSource,
            threadsDataSource: chatRoomsHomeViewController.threadsDataSource,
            viewer: user,
            reportingManager: chatRoomsHomeViewController.reportingManager,
            roomsSelectionBlock: self.showChatRoom()
            )
        
        chatRoomsVC.threadsViewModel!.parentViewController = chatRoomsHomeViewController
        
        chatRoomsHomeViewController.threadsVC = chatRoomsVC
        
        let storiesCarouselVC = AppDelegate.appContainer.makeStoriesViewController(
            uiConfig: chatRoomsHomeViewController.uiConfig,
            dataSource: chatRoomsHomeViewController.matchesDataSource,
            viewer: user,
            roomsSelectionBlock: self.showChatRoomFromNewMatches()
            )
        
        let storiesCarousel = CarouselViewModel(title: nil,
                                                viewController: storiesCarouselVC,
                                                cellHeight: 120)
        
        chatRoomsHomeViewController.storiesCarousel = storiesCarousel
        storiesCarousel.parentViewController = chatRoomsHomeViewController
        
        chatRoomsHomeViewController.assignGenericDataSource()
    }
    
    private func showChatRoom() -> CollectionViewSelectionBlock {
        return {(navController, object, indexPath) in
            if let channel = object as? ChatChannel {
                let vc = AppDelegate.appContainer.makeChatThreadViewController(
                    user: self.user,
                    channel: channel,
                    uiConfig: self.uiConfig!,
                    recipients: channel.participants
                )
            self.navigationController.pushViewController(vc, animated: true)
        }} as CollectionViewSelectionBlock
    }
    
    private func showChatRoomFromNewMatches() -> CollectionViewSelectionBlock {
        return {(navController, object, indexPath) in
            let chatConfig = ChatUIConfiguration(uiConfig: self.uiConfig!)
            if let user = object as? User {
                let id1 = user.uid
                let id2 = self.user.uid
                let channelId = id1 < id2 ? id1 + id2 : id2 + id1
                var channel = ChatChannel(id: channelId, name: user.fullName())
                channel.participants = [user, self.user]
                
                let vc = AppDelegate.appContainer.makeChatThreadViewController(user: self.user, channel: channel, uiConfig: self.uiConfig!, recipients: [user])
                
                navController?.pushViewController(vc, animated: true)
            }
        }
    }
}
