//
//  ChatRoomsViewController.swift
//  ChatApp
//
//  Created by Florian Marcu on 8/20/18.
//  Copyright © 2018 Instamobile. All rights reserved.
//

import UIKit

class ChatRoomsViewController: GenericCollectionViewController {

    let chatConfig: ChatUIConfiguration

    lazy var showChatRoom: (() -> Void)? = nil
    lazy var threadsViewModel: ViewControllerContainerViewModel? = nil
    
    init(uiConfig: UIGenericConfigurationProtocol,
         dataSource: GenericCollectionViewControllerDataSource,
         reportingManager: UserReporter?,
         viewer: User,
         chatConfig: ChatUIConfiguration,
         emptyViewModel: CPKEmptyViewModel?,
         roomsSelectionBlock: @escaping CollectionViewSelectionBlock
         ) {
        self.chatConfig = chatConfig
        
        let collectionVCConfiguration = GenericCollectionViewControllerConfiguration(
            pullToRefreshEnabled: false,
            pullToRefreshTintColor: uiConfig.mainThemeBackgroundColor,
            collectionViewBackgroundColor: uiConfig.mainThemeBackgroundColor,
            collectionViewLayout: LHLiquidCollectionViewLayout(),
            collectionPagingEnabled: false,
            hideScrollIndicators: false,
            hidesNavigationBar: false,
            headerNibName: nil,
            scrollEnabled: false,
            uiConfig: uiConfig,
            emptyViewModel: emptyViewModel
        )
        
        super.init(configuration: collectionVCConfiguration, selectionBlock: roomsSelectionBlock)
        genericDataSource = dataSource
        self.use(adapter: ChatThreadAdapter(uiConfig: configuration.uiConfig, viewer: viewer), for: "ChatChannel")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
