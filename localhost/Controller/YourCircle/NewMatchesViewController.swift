//
//  NewMatchesViewController.swift
//  Contact
//
//  Created by Andrew O'Brien on 12/8/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation
import UIKit

class NewMatchesViewController: GenericCollectionViewController {
    let uiConfig: UIGenericConfigurationProtocol
    let dataSource: GenericCollectionViewControllerDataSource
    let viewer: User
    
    init(
        uiConfig: UIGenericConfigurationProtocol,
        dataSource: GenericCollectionViewControllerDataSource,
        viewer: User,
        selectionBlock: @escaping CollectionViewSelectionBlock
    ) {
        self.uiConfig = uiConfig
        self.dataSource = dataSource
        self.viewer = viewer
        
        let layout = LHCollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let emptyViewModel = CPKEmptyViewModel(image: nil,
                                               title: "No Matches",
                                               description: "Your matches will show up here.",
                                               callToAction: nil)
        
        let configuration = GenericCollectionViewControllerConfiguration(
        pullToRefreshEnabled: false,
        pullToRefreshTintColor: uiConfig.mainThemeBackgroundColor,
        collectionViewBackgroundColor: uiConfig.mainThemeBackgroundColor,
        collectionViewLayout: layout,
        collectionPagingEnabled: false,
        hideScrollIndicators: true,
        hidesNavigationBar: false,
        headerNibName: nil,
        scrollEnabled: true,
        uiConfig: uiConfig,
        emptyViewModel: emptyViewModel)
        
        super.init(configuration: configuration, selectionBlock: selectionBlock)
        self.genericDataSource = dataSource
        self.use(adapter: NewMatchAdapter(uiConfig: uiConfig), for: "User")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
