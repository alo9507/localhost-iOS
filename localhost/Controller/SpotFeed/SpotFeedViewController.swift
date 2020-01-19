import Foundation
import SVProgressHUD
import SnapKit
import UIKit
import CoreLocation

class SpotFeedState {
    static let fresh: SpotFeedState = SpotFeedState(noLocalUsers: false, noFitleredUsers: false, isFetchingUsers: false, isHosting: true, noVisibleLocalUsers: false)
    
    var noLocalUsers: Bool
    var noFitleredUsers: Bool
    var isFetchingUsers: Bool
    var isHosting: Bool
    var noVisibleLocalUsers: Bool
    
    init(
        noLocalUsers: Bool,
        noFitleredUsers: Bool,
        isFetchingUsers: Bool,
        isHosting: Bool,
        noVisibleLocalUsers: Bool
        ) {
            self.noLocalUsers = noLocalUsers
            self.noFitleredUsers = noFitleredUsers
            self.isFetchingUsers = isFetchingUsers
            self.isHosting = isHosting
            self.noVisibleLocalUsers = noVisibleLocalUsers
        }
    
    func description() {
        print("""
        noLocalUsers: \(noLocalUsers)
        
        noFitleredUsers: \(noFitleredUsers)
        
        isFetchingUsers: \(isFetchingUsers)
        
        isHosting: \(isHosting)
            
        noVisibleLocalUsers: \(noVisibleLocalUsers)
        """)
    }
}

class SpotFeedViewController: NiblessViewController {
    var currentState: SpotFeedState = SpotFeedState.fresh
    
    public var spotFeedView: SpotFeedView! {
        guard isViewLoaded else { return nil }
        return (view as! SpotFeedView)
    }
    
    func render() {
        
    }
    
    var userRelationship: UserRelationship = .noRelation
    
    var userSession: UserSession {
        return UserSessionStore.shared.userSession
    }
    
    let viewModel: SpotFeedViewModel
    
    lazy var spotFeedCollectionViewController: UserFeedCollectionViewController = {
        let collectionView = UserFeedCollectionViewController()
        collectionView.viewModel = self.viewModel
        return collectionView
    }()
    
    init(viewModel: SpotFeedViewModel) {
        self.viewModel = viewModel
        super.init()
        self.title = "localhost"
        
        viewModel.delegate = self
    }
    
    override func loadView() {
        self.view = SpotFeedView(viewModel: self.viewModel)
        
        self.addChildViewControllerWithView(spotFeedCollectionViewController)
        spotFeedCollectionViewController.view.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(spotFeedView.headerView.snp.bottom)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    override func viewDidLoad() {
        render()
        configureNavigationBar(isHosting: true)
        viewModel.fetchLocalUsers()
    }
    
    deinit {
        UserSessionStore.unsubscribe(viewModel)
    }
}


// MARK: STATE
extension SpotFeedViewController: SpotFeedViewModelDelegate {
    func allLocalUsers(_ allLocalUsers: [UserCategory]) {
        
    }
    
    func visibleLocalUsers(_ visibleLocalUsers: [UserCategory]) {
        self.spotFeedCollectionViewController.userCategories = visibleLocalUsers
    }
    
    func filteredLocalUsers(_ filteredLocalUsers: [UserCategory]) {
        
    }
    
    func noVisibleLocalUsers() {
        
    }
    
    func userSession(_ userSession: UserSession) {
        // trigger re renders
    }
    
    func allLocalUsers(_ allLocalUsers: [User]) {
        
    }
    
    func noLocalUsers() {
        // SHOW PODIUM WITH THEM AS FIRST AND AN ARROW SAYING "YOU" WITH A START THAT ANIMATES UP
        // Want to be notified when another user is neardby?
        currentState.noLocalUsers = true
        render()
    }
    
    func visibleLocalUsers(_ visibleLocalUsers: [User]) {
        currentState.noVisibleLocalUsers = true
        render()
    }
    
    func isFetchingUsers(_ isFetchingUsers: Bool) {
        currentState.isFetchingUsers = isFetchingUsers
        render()
    }
    
    func sexFilteredUsers(_ sexFilteredUsers: [UserCategory]) {
//        self.spotFeedCollectionViewController.userCategories = sexFilteredUsers
    }
    
    func schoolFilteredUsers(_ schoolFilteredUsers: [UserCategory]) {
//        self.spotFeedCollectionViewController.userCategories = schoolFilteredUsers
    }
    
    func noFilteredUsers() {
        currentState.noFitleredUsers = true
        render()
    }
    
    func isHosting(_ isHosting: Bool) {
        currentState.isHosting = isHosting
        render()
    }
    
    func error(_ error: LHError) {
        let alert = UIAlertController(title: "SpotFeed Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        self.navigationController?.present(alert, animated: true, completion: nil)
    }
}

// MARK: VIEW
extension SpotFeedViewController {
    func configureNavigationBar(isHosting: Bool) {
        navigationController?.navigationBar.tintColor = .white
        configureLeftButton(isHosting: isHosting)
        configureRightBarButon()
    }
    
    func configureLeftButton(isHosting: Bool) {
        let button = UIButton.init(type: .custom)
        if (isHosting) {
            button.setImage(LocalhostStyleKit.imageOfIsHosting(), for: UIControl.State.normal)
        } else {
            button.setImage(LocalhostStyleKit.imageOfIsNotHosting(), for: UIControl.State.normal)
        }
        button.frame = CGRect.init(x: 0, y: 0, width: 35, height: 35)
        let leftBarButtonItem = UIBarButtonItem.init(customView: button)
        leftBarButtonItem.customView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(leftBarButtonItemTapped)))
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    @objc
    func leftBarButtonItemTapped(_ sender: Any) {
        viewModel.toggleHostingButtonPressed()
    }
    
    func configureRightBarButon() {
        let bells = bell()
        bells.frame = CGRect.init(x: 0, y: 0, width: 35, height: 35)
        bells.backgroundColor = .clear
        let notificationsButtonItem = UIBarButtonItem(customView: bells)
        
        self.navigationItem.rightBarButtonItem = notificationsButtonItem
        self.navigationController?.navigationItem.rightBarButtonItem = notificationsButtonItem
        
//        let notificationsButton = UIButton.init(type: .custom)
//        let bell = UIImage.init(named: "ring")
//        bell.
//        notificationsButton.setImage(, for: )
//        notificationsButton.setImage(, for: UIControl.State.normal)
//        notificationsButton.imageView?.contentMode = .scaleAspectFit
//        notificationsButton.contentHorizontalAlignment = .right
//        notificationsButton.imageEdgeInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
//        
//        // frame does not constrain the image
//        notificationsButton.frame = CGRect.init(x: 0, y: 0, width: 20, height: 20)
//        let notificationsButtonItem = UIBarButtonItem.init(customView: notificationsButton)
        
//        let searchButton = UIButton.init(type: .custom)
//        searchButton.setImage(UIImage.init(named: "search"), for: UIControl.State.normal)
//        searchButton.frame = CGRect.init(x: 0, y: 0, width: 20, height: 20)
//        let searchImageButtonItem = UIBarButtonItem.init(customView: searchButton)

//        self.navigationItem.rightBarButtonItems = [notificationsButtonItem]
    }
}

