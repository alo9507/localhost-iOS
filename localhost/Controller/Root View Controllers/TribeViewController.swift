import UIKit
import Firebase
import SVProgressHUD

class YourCircleViewController: UIViewController {
    
    // update currentuser is getting called on this somehow
    var currentUser: CurrentUser? = CurrentUser.currentUser
    
    var selectedProfile: SpotFeedProfileTableViewCell?
    
    var users: [User?] = [] {
        didSet {
            self.tribeTableView.reloadData()
            SVProgressHUD.dismiss()
        }
    }
    
    @IBOutlet weak var tribeTableView: UITableView!
    
    private var usersRepo = FirebaseUsersRepo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.setGradientBackground(colorArray: SettingsService.sharedService.backgroundColors)
        
        tribeTableView.showsVerticalScrollIndicator = false
        
        SVProgressHUD.show()
        
        tribeTableView.delegate = self
        tribeTableView.dataSource = self
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(currentUserDidChangeNotificationReceived(notification:)),
                                               name: CurrentUser.CurrentUserDidChangeNotificationName,
                                               object: nil)
        
        populateCircleFeedBasedOnCurrentUser()
        
        self.configureNavigationBar()
        
        styleTableView()
    }
    
    @objc func currentUserDidChangeNotificationReceived(notification: Notification) {
        currentUser = notification.object as? CurrentUser
        configureNavigationBar()
        
        usersRepo.getAllUsers { (result) in
            switch result {
            case .value(let users):
                self.users = users
            case .error(let error):
                print(error)
            }
        }
        
    }
    
    func populateCircleFeedBasedOnCurrentUser() {
        if let currentUser = self.currentUser {
            
            usersRepo.getMatchedUsers(currentUser: currentUser) { (result) in
                
                switch result {
                case .value(let users):
                    self.users = users
                    var usersInfo = users.map({ (user) -> String in
                        return user.uid
                    })
                case .error(let error):
                    print(error)
                }
                
            }
        } else {
            usersRepo.getAllUsers { (result) in
                
                switch result {
                case .value(let users):
                    self.users = users
                case .error(let error):
                    print(error)
                }
                
            }
        }
        
    }
    
    func styleTableView() {
        tribeTableView.register(UINib(nibName: "SpotFeedProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "spotFeedProfileCell")
        tribeTableView.separatorStyle = .none
    }
    
    func configureNavigationBar() {
        navigationItem.hidesBackButton = true
        
        let backButton = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.backBarButtonItem = backButton
        
        let containView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        containView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(profileButtonPressed)))
        
        let imageview = UIImageView(frame: CGRect(x: 0, y: 0, width: 34, height: 34))
        imageview.contentMode = .scaleAspectFit
        imageview.layer.cornerRadius = imageview.frame.size.width / 2
        imageview.layer.masksToBounds = true
        
        if currentUser != nil {
            imageview.loadImageUsingCache(withUrl: currentUser!.profileImageUrl)
        } else {
            imageview.image = UIImage(named: "noProfilePhoto")
        }
        
        containView.addSubview(imageview)
        let rightBarButton = UIBarButtonItem(customView: containView)
        self.navigationItem.rightBarButtonItem = rightBarButton
        
    }
    
    @objc func profileButtonPressed() {
        if let currentUser = currentUser {
            let myProfileViewController = UIStoryboard.profileDetailViewController() as! ProfileDetailViewController
            myProfileViewController.user = currentUser
            myProfileViewController.userProfileMode = true
            navigationController?.pushViewController(myProfileViewController, animated: true)
        } else {
            let authenticationViewController = UIStoryboard.authenticationVC() as! AuthenticationViewController
            navigationController?.pushViewController(authenticationViewController, animated: true)
        }
    }
    
    func sendUserToRegistration() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let initialRegistrationVC = storyboard.instantiateViewController(withIdentifier: "Registration_EmailPasswordVC")
        navigationController?.pushViewController(initialRegistrationVC, animated: true)
    }
    
}

extension YourCircleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tribeTableView.dequeueReusableCell(withIdentifier: "spotFeedProfileCell") as! SpotFeedProfileTableViewCell
        cell.user = users[indexPath.section]
        return cell
    }
}

extension YourCircleViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tribeTableView.deselectRow(at: indexPath, animated: false)
        
        if currentUser == nil {
            let alert = UIAlertController(title: "Join to See!", message: "If you want to learn more about \(users[indexPath.section]!.name) you'll have to register", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Join", style: .default, handler: { action in self.sendUserToRegistration()}))
            alert.addAction(UIAlertAction(title: "Don't Join", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
        } else {
            
            selectedProfile = tribeTableView.cellForRow(at: indexPath) as? SpotFeedProfileTableViewCell
            
            let detailController = UIStoryboard.profileDetailViewController()
            
            detailController.user = users[indexPath.section]!
            
            detailController.userRelationship = currentUser!.determineUserRelationship(userUid: selectedProfile!.user!.uid)
            
            navigationController?.pushViewController(detailController, animated: true)
        }
    }
}
