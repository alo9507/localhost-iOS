//
//  localhostFactory.swift
//  Contact
//
//  Created by Andrew O'Brien on 8/11/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class LocalhostAppDependencyContainer {
    
    // MARK: - Child Dependency Containers
    lazy var registrationContainer = LocalhostRegistrationDependencyContainer(appDependencyContainer: self)
    lazy var newUserEducationContainer = LocalhostTutorialDependencyContainer()
    
    // MARK: - Repositories
    public let userSessionRepository: UserSessionRepository
    public let userRepository: UserRepository
    public let socialGraphRepository: SocialGraphRepository
    public let channelsRepository: ChannelsRepository
    public let userReporter: UserReporter
    
    // MARK: - Data Sources
    public let chatRoomsDataSource: GenericCollectionViewControllerDataSource
    public let matchesDataSource: MatchesDataSource
    
    // MARK: - Navigation Containers
    private var mainTabBarController: MainTabBarController?
    private var settingsNavigationController: CustomNavigationViewController?
    public var spotFeedNavigationController: CustomNavigationViewController?
    private var yourCircleNavigationController: CustomNavigationViewController?
    
    // MARK: - Services
    lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        return locationManager
    }()
    
    let firstLaunchService = FirstLaunch(userDefaults: .standard, key: "wasLaunchedBefore")
    // Uncommenting this line will simulate a first launch experience every launch
    //    let firstLaunchService = FirstLaunch.alwaysFirst()
    
    /// The environment determines what dependencies are used to initialize the LocalhostAppDependencyContainer
    /// - Parameter environment: .local or .production
    init(environment: Environment) {
        switch environment {
        case .local:
            userRepository = MockUsersRepo(localUsers: MockObjects.mockLocalUsers())
            userSessionRepository = MockUserSessionRepository()
            socialGraphRepository = MockSocialGraphRepository(userSessionRepository: userSessionRepository)
            channelsRepository = MockChannelsRepository()
            chatRoomsDataSource = MockChannelsDataSource(channelsRepository: channelsRepository)
            matchesDataSource = FirebaseMatchesDataSource(socialGraphRepository: socialGraphRepository)
            userReporter = MockUserReporter()
        case .production:
            userRepository = FirestoreUserRepository()
            userSessionRepository = LocalhostUserSessionRepository(
                dataStore: FileUserSessionDataStore(),
                userRepository: userRepository
            )
            socialGraphRepository = FirebaseSocialGraphManager(userRepostitory: userRepository, userSessionRepository: userSessionRepository)
            userRepository.socialGraphRepository = socialGraphRepository
            channelsRepository = FirebaseChannelsRepository()
            chatRoomsDataSource = FirebaseChannelsDataSource(channelsRepository: channelsRepository)
            matchesDataSource = FirebaseMatchesDataSource(socialGraphRepository: socialGraphRepository)
            userReporter = FirebaseUserReporter()
        }
    }
    
    // MARK: - Coordinator Factory Methods
    public func makeApplicationCoordinator(window: UIWindow) -> ApplicationCoordinator {
        return ApplicationCoordinator(window: window)
    }
    
    func makeAuthenticationCoordinator(presenter: UIViewController) -> AuthenticationCoordinator {
        return AuthenticationCoordinator(presenter: presenter)
    }
    
    func makeAccountCoordinator(presenter: UIViewController) -> AccountCoordinator {
        return AccountCoordinator(presenter: presenter)
    }
    
    func makePreferencesCoordinator(presenter: UIViewController) -> PreferencesCoordinator {
        return PreferencesCoordinator(presenter: presenter)
    }
    
    func makeMatchesCoordinator() -> MatchesCoordinator {
        return MatchesCoordinator(navigationController: yourCircleNavigationController!)
    }
    
    func makeChatRoomsCoordinator() -> ChatRoomsHomeCoordinator {
        return ChatRoomsHomeCoordinator (navigationController: yourCircleNavigationController!)
    }
    
    func makeYourCircleCoordinator() -> YourCircleCoordinator {
        let yourCircleNav = makeCustomNavigationViewController(rootViewController: makeYourCircleViewController())
        yourCircleNavigationController = yourCircleNav
        return YourCircleCoordinator(navigationController: yourCircleNavigationController!)
    }
    
    func makeSpotFeedCoordinator() -> SpotFeedCoordinator {
        let spotFeedNav = makeCustomNavigationViewController(rootViewController: makeSpotFeedViewController())
        spotFeedNavigationController = spotFeedNav
        return SpotFeedCoordinator(navigationController: spotFeedNavigationController!)
    }
    
    func makeSettingsCoordinator() -> SettingsCoordinator {
        let settingsNav = makeCustomNavigationViewController(rootViewController: makeSettingsViewController())
        settingsNavigationController = settingsNav
        return SettingsCoordinator(navigationController: settingsNavigationController!)
    }
    
    func makeProfileDetailCoordinator(_ navigationController: UINavigationController, _ featuredUser: User, _ origin: Origin) -> ProfileDetailCoordinator {
        return ProfileDetailCoordinator(
            featuredUser: featuredUser,
            origin: origin,
            navigationController: navigationController,
            reportingManager: userReporter
        )
    }
    
    func makeMainTabBarCoordinator(presenter: UIViewController, userSession: UserSession) -> TabBarCoordinator {
        return TabBarCoordinator(presenter: presenter, userSession: userSession)
    }
    
    func makeRegistrationCoordinator(presenter: UIViewController) -> RegistrationCoordinator {
        return RegistrationCoordinator(presenter: presenter, userRepository: userRepository, userSessionRepository: userSessionRepository)
    }
    
    func makeTutorialCoordinator(presenter: UIViewController) -> TutorialCoordinator {
        return TutorialCoordinator(presenter: presenter)
    }
    
    // MARK: - Navigation Container Factory Methods
    func makeMainTabBarController() -> MainTabBarController {
        let mainTabBar =  MainTabBarController(
            yourCircleNavigationController: yourCircleNavigationController!,
            spotFeedNavigationController: spotFeedNavigationController!,
            settingsNavigationController: settingsNavigationController!
        )
        
        mainTabBarController = mainTabBar
        
        return mainTabBarController!
    }
    
    func makeCustomNavigationViewController(rootViewController: UIViewController) -> CustomNavigationViewController {
        return CustomNavigationViewController(rootViewController: rootViewController)
    }
    
    // MARK: - ViewController Factory Methods
    
    public func makeMainViewController() -> MainViewController {
        let mainViewModel = MainViewModel(firstLaunchService: firstLaunchService, userSessionRepository: userSessionRepository, usersRepo: userRepository)
        return MainViewController(viewModel: mainViewModel)
    }
    
    func makeRegistrationPageViewController() -> OnboardingPageViewController {
        return registrationContainer.makeRegistrationPageViewController()
    }
    
    func makeYourCircleViewController() -> YourCircleViewController {
        let yourCircleViewModel = YourCircleViewModel()
        return YourCircleViewController(matchesViewController: makeMatchesViewController(), viewModel: yourCircleViewModel)
    }
    
    func makeMatchesViewController() -> MatchesViewController {
        let matchesViewModel = MatchesViewModel(socialGraphRepository: socialGraphRepository)
        return MatchesViewController(viewModel: matchesViewModel)
    }
    
    func makeAccountViewController() -> AccountViewController {
        let accountViewModel = AccountViewModel(userSessionRepository: userSessionRepository, userRepository: userRepository)
        return AccountViewController(viewModel: accountViewModel)
    }
    
    func makePreferencesViewController() -> PreferencesViewController {
        let preferencesViewModel = PreferencesViewModel(userSessionRepository: userSessionRepository)
        return PreferencesViewController(viewModel: preferencesViewModel)
    }
    
    func makeResetEmailVC() -> PasswordResetEmail {
        return PasswordResetEmail()
    }
    
    func makeChatRoomsHomeViewController(user: User) -> ChatRoomsHomeViewController {
        matchesDataSource.viewer = user
        matchesDataSource.loadFirst()
        let config = LHUIConfiguration()
        
        let vc = ChatRoomsHomeViewController(
            uiConfig: config,
            matchesDataSource: matchesDataSource,
            threadsDataSource: chatRoomsDataSource,
            reportingManager: userReporter,
            user: user
        )
        
        return vc
    }
    
    func makeChatRoomsViewController(
        uiConfig: UIGenericConfigurationProtocol,
        matchesDataSource: MatchesDataSource,
        threadsDataSource: GenericCollectionViewControllerDataSource,
        viewer: User,
        reportingManager: UserReporter?,
        roomsSelectionBlock: @escaping CollectionViewSelectionBlock
    ) -> ChatRoomsViewController {
        let chatConfig = ChatUIConfiguration(uiConfig: uiConfig)
        
        let emptyViewModel = CPKEmptyViewModel(image: nil,
                                               title: "No Conversations",
                                               description: "Your conversations will show up here. Match with people and start messaging them.", callToAction: nil)
        
        let threadsVC = ChatRoomsViewController(
            uiConfig: uiConfig,
            dataSource: threadsDataSource,
            reportingManager: reportingManager,
            viewer: viewer,
            chatConfig: chatConfig,
            emptyViewModel: emptyViewModel,
            roomsSelectionBlock: roomsSelectionBlock
        )
        
        let threadsViewModel = ViewControllerContainerViewModel(viewController: threadsVC,
                                                                cellHeight: nil,
                                                                subcellHeight: 85,
                                                                minTotalHeight: 200)
        
        threadsVC.threadsViewModel = threadsViewModel
        
        return threadsVC
    }
    
    func makeStoriesViewController(
        uiConfig: UIGenericConfigurationProtocol,
        dataSource: GenericCollectionViewControllerDataSource,
        viewer: User,
        roomsSelectionBlock: @escaping CollectionViewSelectionBlock
    ) -> NewMatchesViewController {
        
        let vc = NewMatchesViewController(
            uiConfig: uiConfig,
            dataSource: dataSource,
            viewer: viewer,
            selectionBlock: roomsSelectionBlock
        )
        
        return vc
    }
    
    func makeChatThreadViewController(
        user: User,
        channel: ChatChannel,
        uiConfig: UIGenericConfigurationProtocol,
        recipients: [User]
    ) -> ChatThreadViewController {
        
        let chatConfig = ChatUIConfiguration(uiConfig: uiConfig)
        
        let vc = ChatThreadViewController(
            user: user,
            channel: channel,
            uiConfig: chatConfig,
            recipients: channel.participants,
            channelsRepository: channelsRepository
        )
        
        if channel.participants.count == 2 {
            let otherUser = (user.uid == channel.participants.first?.uid) ? channel.participants[1] : channel.participants[0]
            vc.title = otherUser.fullName()
        }
        
        return vc
    }
    
    func makeNewUserEducationPageViewController() -> OnboardingPageViewController {
        return newUserEducationContainer.makeNewUserEducationPageViewController()
    }
    
    func makeAuthenticationViewController() -> AuthenticationViewController {
        let authenticationViewModel = AuthenticationViewModel(userSessionRepository: userSessionRepository, userRepo: userRepository)
        return AuthenticationViewController(viewModel: authenticationViewModel)
    }
    
    func makeSpotFeedViewController() -> SpotFeedViewController {
        return SpotFeedViewController(viewModel: self.makeSpotFeedViewModel())
    }
    func makeSpotFeedViewModel() -> SpotFeedViewModel {
        return SpotFeedViewModel(userRepository: userRepository, locationManager: locationManager, userSessionRepository: userSessionRepository)
    }
    
    func makeEditStatusViewController() -> EditStatusViewController {
        let editStatusViewModel = EditStatusViewModel(userRepository: userRepository, userSessionRepository: userSessionRepository)
        return EditStatusViewController(viewModel: editStatusViewModel)
    }
    
    func makeShowMyVC() -> ShowMyViewController {
        let showMyViewModel = ShowMyViewModel(userSessionRepository: userSessionRepository)
        return ShowMyViewController(viewModel: showMyViewModel)
    }
    
    func makeSettingsViewController() -> SettingsViewController {
        let settingsViewModel =  SettingsViewModel(userSessionRepository: userSessionRepository)
        return SettingsViewController(viewModel: settingsViewModel)
    }
    
    func makeLocationAccessVC() -> LocationAccess {
        let locationAccessViewModel = LocationAccessViewModel(locationManager: locationManager)
        return LocationAccess(viewModel: locationAccessViewModel)
    }
    
    func makeChatRoomViewController(currentUser: User, recipient: User) -> ChatThreadViewController {
        let config = LHUIConfiguration()
        let chatConfig = ChatUIConfiguration(uiConfig: config)
        
        let id1 = currentUser.uid
        let id2 = recipient.uid
        let channelId = id1 < id2 ? id1 + id2 : id2 + id1
        
        var channel = ChatChannel(id: channelId, name: recipient.firstName)
        
        channel.participants = [currentUser, recipient]
        
        return ChatThreadViewController(
            user: currentUser,
            channel: channel,
            uiConfig: chatConfig,
            recipients: [recipient],
            channelsRepository: channelsRepository
        )
    }
    
    func makeProfileDetailViewController(_ featuredUser: User, _ origin: Origin) -> ProfileDetailViewController {
        let profileDetailViewModel = ProfileDetailViewModel(featuredUser: featuredUser, origin: origin, userRepository: userRepository, socialGraphRepository: socialGraphRepository)
        return ProfileDetailViewController(featuredUser: featuredUser, origin: origin, viewModel: profileDetailViewModel)
    }
    func makePreviewProfileViewController(_ featuredUser: User, _ origin: Origin) -> PreviewProfileViewController {
        let profileDetailViewModel = ProfileDetailViewModel(featuredUser: featuredUser, origin: origin, userRepository: userRepository, socialGraphRepository: socialGraphRepository)
        return PreviewProfileViewController(featuredUser: featuredUser, origin: origin, viewModel: profileDetailViewModel)
    }
    
    func makeEditProfileViewController(_ featuredUser: User) -> EditProfileViewController {
        let editProfileViewModel = EditProfileViewModel(userSessionRepository: userSessionRepository, userRepository: userRepository)
        return EditProfileViewController(viewModel: editProfileViewModel)
    }
    
    func makeChangeProfileViewController(_ featuredUser: User) -> ChangeProfileViewController {
        let changeProfileViewModel = ChangeProfileViewModel(userSessionRepository: userSessionRepository, userRepository: userRepository)
        return ChangeProfileViewController(viewModel: changeProfileViewModel)
    }
    
    func makeVisibilitySettingsViewController() -> VisibilitySettingsViewController {
        let visibilitySettingsViewModel = VisibilitySettingsViewModel(userRepo: userRepository)
        return VisibilitySettingsViewController(viewModel: visibilitySettingsViewModel)
    }
}
