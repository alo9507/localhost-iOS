import UIKit
import Firebase
import SVProgressHUD

class YourCircleViewController: NiblessViewController, YourCircleViewModelDelegate {
    var yourCircleTableView: UITableView = UITableView()
    
    var matchesView: UIView!
    var chatRoomsView: UIView!
    
    var matchesViewController: MatchesViewController
    var chatRoomsHomeViewController: ChatRoomsHomeViewController
    
    var userSession: UserSession {
        return UserSessionStore.shared.userSession
    }
    
    var viewModel: YourCircleViewModel
    
    lazy var yourCircleSegmentedControl: UISegmentedControl = {
        let circleImage = UIImage(image: UIImage(named: "many-friends-icon-25"), scaledTo: CGSize(width: 35, height: 35))
        let messagesImage = UIImage(image: UIImage(named: "chat-filled-icon-1"), scaledTo: CGSize(width: 35, height: 35))
        
        let items: [UIImage] = [
            messagesImage!,
            circleImage!
        ]
        
        let segmentedControl = UISegmentedControl(items: items)
        
        segmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "AvenirNext-Bold", size: 15.0)!
        ], for: .normal)
        
        segmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "AvenirNext-Bold", size: 15.0)!
        ], for: .selected)
        
        if #available(iOS 13.0, *) {
            segmentedControl.selectedSegmentTintColor = UIColor.init(hexString: "#9917C4", withAlpha: 0.7)
        } else {
            segmentedControl.tintColor = UIColor.init(hexString: "#9917C4", withAlpha: 0.7)
        }
        
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.apportionsSegmentWidthsByContent = true
        segmentedControl.addTarget(viewModel, action: #selector(YourCircleViewModel.segmentedControlToggled(_:)), for: .valueChanged)
        return segmentedControl
    }()
    
    init(
        matchesViewController: MatchesViewController,
        viewModel: YourCircleViewModel
    ) {
        self.matchesViewController = matchesViewController
        
        self.chatRoomsHomeViewController = AppDelegate.appContainer.makeChatRoomsHomeViewController(user: UserSessionStore.shared.userSession.user)
        self.viewModel = viewModel
        
        super.init()
        
        viewModel.delegate = self
        
        render()
    }
    
    deinit {
        UserSessionStore.unsubscribe(viewModel)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if self.yourCircleSegmentedControl.selectedSegmentIndex == 0 {
            self.view.addSubview(chatRoomsHomeViewController.view)
            addChild(chatRoomsHomeViewController)
            chatRoomsHomeViewController.didMove(toParent: parent)
            chatRoomsHomeViewController.view.isHidden = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if self.yourCircleSegmentedControl.selectedSegmentIndex == 0 {
            self.view.addSubview(chatRoomsHomeViewController.view)
            addChild(chatRoomsHomeViewController)
            chatRoomsHomeViewController.didMove(toParent: parent)
            chatRoomsHomeViewController.view.isHidden = false
        }
    }
}

extension YourCircleViewController {
    func render() {
        constructHierarchy()
        activateConstraints()
    }
    
    func constructHierarchy() {
        self.navigationItem.titleView = yourCircleSegmentedControl
        
        self.view.addSubview(matchesViewController.view)
        addChild(matchesViewController)
        matchesViewController.didMove(toParent: parent)
        chatRoomsHomeViewController.view.isHidden = true
        
        self.view.addSubview(chatRoomsHomeViewController.view)
        addChild(chatRoomsHomeViewController)
        chatRoomsHomeViewController.didMove(toParent: parent)
        chatRoomsHomeViewController.view.isHidden = true
    }
    
    func activateConstraints() {
        matchesViewController.view.snp.makeConstraints { (make) in
            make.bottom.top.left.right.equalToSuperview()
        }
        
        chatRoomsHomeViewController.view.snp.makeConstraints { (make) in
            make.bottom.top.left.right.equalToSuperview()
        }
    }
}

extension YourCircleViewController {
    func userSession(_ userSession: UserSession) {
        render()
    }
    
    func currentSelection(_ currentSelection: Int) {
        switch currentSelection {
        case 0:
            matchesViewController.view.isHidden = true
            chatRoomsHomeViewController.view.isHidden = false
        case 1:
            matchesViewController.view.isHidden = false
            chatRoomsHomeViewController.view.isHidden = true
        default:
            fatalError()
        }
    }
}
