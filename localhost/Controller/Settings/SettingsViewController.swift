import UIKit
import SnapKit

extension UIView {
    func makeCircular() {
        self.layer.cornerRadius = min(self.frame.size.height, self.frame.size.width) / 2.0
        self.clipsToBounds = true
    }
}

class SettingsViewController: NiblessViewController {
    
    let options = ["Preferences", "Account", "Help Center"]
    let viewModel: SettingsViewModel
    
    var userSession: UserSession {
        return UserSessionStore.shared.userSession
    }
    
    lazy var profileImageView: UIImageView = {
        let profileImageView = UIImageView()
        profileImageView.frame = CGRect.zero
        profileImageView.isUserInteractionEnabled = true
        
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        
        let placeholderImage = UIImage(named: "noProfilePhoto")
        let placeholderImageView = UIImageView(image: UIImage(named: "noProfilePhoto"))
        
        guard let imageUrl = URL(string: UserSessionStore.user.profileImageUrl) else {
            return placeholderImageView
        }
        
        profileImageView.sd_setImage(with: imageUrl) { (image, error, _, _) in
            DispatchQueue.main.async {
                profileImageView.layoutIfNeeded()
                profileImageView.layoutSubviews()
                profileImageView.roundCorners()
            }
        }
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(editProfileTapped)))
        return profileImageView
    }()
    
    lazy var editIcon: UIView = {
        let editIcon = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        editIcon.backgroundColor = .white
        
        let pencilIcon = UIImageView(image: UIImage(named: "edit-pencil"))
        
        editIcon.addSubview(pencilIcon)
        pencilIcon.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(30)
            make.width.height.equalTo(35)
            make.centerX.equalToSuperview()
        }
        
        let name = UILabel()
        name.text = UserSessionStore.user.firstName
        name.textColor = .black
        // size based on name?
        name.font = Fonts.avenirNext_bold(25)
        name.textAlignment = .center
        
        editIcon.addSubview(name)
        name.snp.makeConstraints { (make) in
            make.top.equalTo(pencilIcon.snp.bottom).offset(5)
            make.height.equalTo(20)
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        editIcon.layer.cornerRadius = 80
        
        editIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(editProfileTapped)))
        return editIcon
    }()
    
    lazy var settingsTableView: UITableView = {
        let settingsTableView = UITableView()
        settingsTableView.register(CustomTableCell.self, forCellReuseIdentifier: "cellId")
        settingsTableView.backgroundColor = .clear
        settingsTableView.separatorStyle = .none
        settingsTableView.isScrollEnabled = false
        return settingsTableView
    }()
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        super.init()
        
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        title = "You"
        render()
    }
    
}

// MARK: Setup UI
extension SettingsViewController {
    func render() {
        constructHierarchy()
        activatesConstraints()
    }
    
    func constructHierarchy() {
        view.addSubview(profileImageView)
        view.addSubview(editIcon)
        view.addSubview(settingsTableView)
    }
    
    func activatesConstraints() {
        profileImageView.snp.makeConstraints { (make) in
            make.height.width.equalTo(250)
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(60)
        }
        
        editIcon.snp.makeConstraints { (make) in
            make.centerY.equalTo(profileImageView.snp.bottom).offset(15)
            make.centerX.equalTo(profileImageView)
            make.width.height.equalTo(150)
        }
        
        settingsTableView.snp.makeConstraints { (make) in
            make.top.equalTo(profileImageView.snp.bottom).offset(100)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    @objc
    func editProfileTapped(_ sender: UITapGestureRecognizer) {
        self.viewModel.showEditProfile?()
    }
}

// MARK: SettingsTableViewDataSource
extension SettingsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! CustomTableCell
        cell.textLabel?.text = options[indexPath.row]
        cell.textLabel?.font = UIFont(name: "AvenirNext-Bold", size: 20.0)!
        cell.textLabel?.textColor = .white
        
        return cell
    }
}

// MARK: UITableViewDelegate
extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        settingsTableView.deselectRow(at: indexPath, animated: false)
        
        switch indexPath.row {
        case 0:
            self.viewModel.showPreferences?()
        case 1:
            self.viewModel.showAccount?()
        case 2:
            return
        case 3:
            return
        default:
            return
        }
    }
}

class CustomTableCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        textLabel?.textColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

