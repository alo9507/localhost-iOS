import Firebase
import UserNotificationsUI
import UserNotifications
import SnapKit
import UIKit
import SnapKit

public struct ProfileDetailState {
    var userSession: UserSession
    var origin: Origin
    var featuredUser: User
    var userRelationship: UserRelationship
    
    init(
        userSession: UserSession,
        origin: Origin,
        featuredUser: User,
        userRelationship: UserRelationship
    ) {
        self.userSession = userSession
        self.origin = origin
        self.featuredUser = featuredUser
        self.userRelationship = userRelationship
    }
    
    func description() {
        print("""
        userSession: \(userSession)
        
        origin: \(origin)
        
        featuredUser: \(featuredUser.fullName())
        
        userRelationship: \(userRelationship)
        """)
    }
}

class ProfileDetailViewController: NiblessViewController, UNUserNotificationCenterDelegate, ProfileDetailViewModelDelegate {
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .clear
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    lazy var interactionButton: UIImageView = {
        let interactionButton = UIImageView(frame: .zero)
        if self.origin == .myProfile {
            interactionButton.isHidden = true
        }
        let tapGestureRecognizer = UITapGestureRecognizer(target: viewModel, action: #selector(ProfileDetailViewModel.connectButtonTapped))
        interactionButton.addGestureRecognizer(tapGestureRecognizer)
        interactionButton.isUserInteractionEnabled = true
        return interactionButton
    }()
    
    lazy var profileDetailView: ProfileDetailView = {
        let profileDetailView = ProfileDetailView(self.featuredUser, self.origin, self.viewModel)
        return profileDetailView
    }()
    
    var userSession: UserSession {
        return UserSessionStore.shared.userSession
    }
    
    var currentState: ProfileDetailState
    
    let viewModel: ProfileDetailViewModel
    let featuredUser: User
    let origin: Origin
    let reportingManager: UserReporter?
    
    var userRelationship: UserRelationship {
        get {
            userSession.user.determineUserRelationship(userUid: featuredUser.uid)
        }
    }
    
    init(featuredUser: User, origin: Origin, viewModel: ProfileDetailViewModel) {
        self.featuredUser = featuredUser
        self.origin = origin
        self.reportingManager = FirebaseUserReporter()
        
        self.currentState = ProfileDetailState(
            userSession: UserSessionStore.shared.userSession,
            origin: origin,
            featuredUser: featuredUser,
            userRelationship: UserSessionStore.shared.userSession.user.determineUserRelationship(userUid: featuredUser.uid)
            )
        
        self.viewModel = viewModel
        super.init()
        viewModel.delegate = self
        view.backgroundColor = UIColor.lhPurple
        setupUI()
        render()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        UserSessionStore.unsubscribe(viewModel)
    }
}

// MARK: RENDER
extension ProfileDetailViewController {
    func render() {
        switch currentState.userRelationship {
        case .match:
            interactionButton.stopRotating()
            interactionButton.image = UIImage(named: "enabled_chat")
        case .inbound:
            interactionButton.stopRotating()
            interactionButton.image = UIImage(named: "nodicon")
        case .outbound:
            interactionButton.stopRotating()
            interactionButton.image = UIImage(named: "disabled_chat")
            profileDetailView.layoutIfNeeded()
        case .noRelation:
            interactionButton.stopRotating()
            interactionButton.image = UIImage(named: "nodicon")
        }
        
        switch origin {
        case .myProfile:
            interactionButton.isHidden = true
            profileDetailView.mutualConnectionCount.isHidden = true
            // show editing stuff
        case .spotFeed:
            return
        case .nods:
            return
        case .matches:
            return
        }
    }
}

// MARK: SETUP
extension ProfileDetailViewController {
    func setupUI() {
        constructHierarchy()
        activateConstraints()
    }
    
    func currentUserSession(_ userSession: UserSession) {
        currentState.userSession = userSession
        currentState.userRelationship = userSession.user.determineUserRelationship(userUid: featuredUser.uid)
        render()
    }
}

// MARK: VIEW
extension ProfileDetailViewController {
    func constructHierarchy() {
        view.addSubview(scrollView)
        view.addSubview(interactionButton)
        scrollView.addSubview(profileDetailView)
    }
    
    func activateConstraints() {
        activateScrollViewConstraints()
    }
    
    func activateScrollViewConstraints() {
        
        scrollView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.left.right.equalToSuperview()
        }
        
        profileDetailView.snp.makeConstraints { (make) in
            make.top.equalTo(scrollView.snp.top)
            make.bottom.equalTo(scrollView.snp.bottom)
        }
        
        interactionButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(25)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(50)
        }
    }
}

// MARK: STATE
extension ProfileDetailViewController {
    func error(_ error: LHError) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func optimisticallyUpdateInteractionIcon() {
        switch userSession.user.determineUserRelationship(userUid: featuredUser.uid) {
        case .match:
            fatalError()
        case .inbound:
            self.configureMatch()
        case .outbound:
            fatalError()
        case .noRelation:
            self.configureNoChat()
        }
    }
    
    func rollbackInteractionIcon() {
        switch userSession.user.determineUserRelationship(userUid: featuredUser.uid) {
        case .match:
            fatalError()
        case .inbound:
            interactionButton.stopRotating()
            interactionButton.image = UIImage(named: "nodicon")
            profileDetailView.layoutIfNeeded()
        case .outbound:
            interactionButton.stopRotating()
            interactionButton.image = UIImage(named: "disabled_chat")
            profileDetailView.layoutIfNeeded()
        case .noRelation:
            interactionButton.stopRotating()
            interactionButton.image = UIImage(named: "nodicon")
            profileDetailView.layoutIfNeeded()
        }
    }
    
    func configureMatch() {
        interactionButton.stopRotating()
        // show match screen
        interactionButton.image = UIImage(named: "enabled_chat")
        profileDetailView.layoutIfNeeded()
    }
    
    func configureNoChat() {
        interactionButton.stopRotating()
        interactionButton.image = UIImage(named: "disabled_chat")
        profileDetailView.layoutIfNeeded()
    }
}
