//
//  ChatRoomsHomeViewController.swift
//  DatingApp
//
//  Created by Florian Marcu on 1/25/19.
//  Copyright © 2019 Instamobile. All rights reserved.
//

import UIKit

class ChatRoomsHomeViewController: GenericCollectionViewController {
    let threadsDataSource: GenericCollectionViewControllerDataSource
    let matchesDataSource: MatchesDataSource
    var viewer: User? = nil
    let uiConfig: UIGenericConfigurationProtocol
    let reportingManager: UserReporter?
    lazy var threadsVC: ChatRoomsViewController? = nil
    lazy var storiesCarousel: CarouselViewModel? = nil
    
    init(uiConfig: UIGenericConfigurationProtocol,
         matchesDataSource: MatchesDataSource,
         threadsDataSource: GenericCollectionViewControllerDataSource,
         reportingManager: UserReporter?,
         user: User
         ) {
        self.uiConfig = uiConfig
        self.matchesDataSource = matchesDataSource
        self.threadsDataSource = threadsDataSource
        self.reportingManager = reportingManager
        
        let collectionVCConfiguration = GenericCollectionViewControllerConfiguration(
            pullToRefreshEnabled: false,
            pullToRefreshTintColor: .white,
            collectionViewBackgroundColor: uiConfig.mainThemeBackgroundColor,
            collectionViewLayout: LHLiquidCollectionViewLayout(),
            collectionPagingEnabled: false,
            hideScrollIndicators: false,
            hidesNavigationBar: false,
            headerNibName: nil,
            scrollEnabled: true,
            uiConfig: uiConfig,
            emptyViewModel: nil
        )
        
        super.init(configuration: collectionVCConfiguration, selectionBlock: { (navController, object, indexPath) in })
        
        self.viewer = user
        guard let viewer = viewer else { fatalError() }
        
        self.use(adapter: ViewControllerContainerRowAdapter(), for: "ViewControllerContainerViewModel")

        self.registerReuseIdentifiers()

        if let threadsDataSource = threadsDataSource as? FirebaseChannelsDataSource {
            threadsDataSource.user = user
        }
    }
    
    public func assignGenericDataSource() {
        self.genericDataSource = GenericLocalHeteroDataSource(items: [self.storiesCarousel!, self.threadsVC!.threadsViewModel!])
        self.genericDataSource?.loadFirst()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    fileprivate func titleView() -> UIView {
        let titleView = UIImageView(image: UIImage.localImage("chat-filled-icon", template: true))
        titleView.snp.makeConstraints({ (maker) in
            maker.width.equalTo(30.0)
            maker.height.equalTo(30.0)
        })
        titleView.tintColor = uiConfig.mainThemeForegroundColor
        return titleView
    }
}
