//
//  YourCircleRootView.swift
//  Contact
//
//  Created by Andrew O'Brien on 9/2/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation
import SnapKit
import UIKit
import RevealingSplashView

class MatchesViewController: NiblessViewController {
    var matchesTableView: UITableView = {
        let matchesTableView = UITableView()
        matchesTableView.register(SpotFeedProfileTableViewCell.self, forCellReuseIdentifier: "SpotFeedProfileTableViewCell")
        matchesTableView.separatorStyle = .none
        matchesTableView.showsVerticalScrollIndicator = false
        matchesTableView.backgroundColor = .clear
        
        matchesTableView.estimatedRowHeight = 85.0
        matchesTableView.rowHeight = UITableView.automaticDimension
        return matchesTableView
    }()
    
    var noMatchesLabel: UILabel = {
        let noMatchesLabel = UILabel(frame: .zero)
        noMatchesLabel.font = UIFont(name: "AvenirNext-Bold", size: 20.0)
        noMatchesLabel.textAlignment = .center
        noMatchesLabel.numberOfLines = 3
        noMatchesLabel.textColor = UIColor.white
        noMatchesLabel.text = "No one in your circle"
        noMatchesLabel.isHidden = true
        return noMatchesLabel
    }()
    
    var revealingSplashView: RevealingSplashView = {
        let revealingSplashView = RevealingSplashView(iconImage: UIImage(named: "LocalhostAppIconRound")!, iconInitialSize: CGSize(width: 80, height: 80), backgroundColor: UIColor.white)
        return revealingSplashView
    }()
    
    var matches: [User] = [] {
        didSet {
            DispatchQueue.main.async {
                self.matchesTableView.reloadData()
            }
        }
    }
    
    var nods: [User] = [] {
        didSet {
            DispatchQueue.main.async {
                self.matchesTableView.reloadData()
            }
        }
    }
    
    var data: [[User]] {
        return [nods, matches]
    }
    
    let viewModel: MatchesViewModel
    var userSession: UserSession {
        return UserSessionStore.shared.userSession
    }
    
    init(viewModel: MatchesViewModel) {
        self.viewModel = viewModel
        super.init()
        
        viewModel.delegate = self
        
        matchesTableView.delegate = self
        matchesTableView.dataSource = self
        
        render()
    }
    
    override func viewDidLoad() {
        viewModel.loadMatches()
        viewModel.loadNods()
    }
    
    deinit {
        UserSessionStore.unsubscribe(viewModel)
    }
    
}

// MARK: VIEW
extension MatchesViewController {
    func render() {
        constructHierarchy()
        activateConstraints()
    }
    
    func constructHierarchy() {
        view.addSubview(matchesTableView)
        view.addSubview(noMatchesLabel)
    }
    
    func activateConstraints() {
        matchesTableView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
        }
        
        noMatchesLabel.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.center.equalToSuperview()
        }
    }
    
    func configureNavigationBar(authenticated: Bool) {
        configureRightButton()
    }
    
    func configureRightButton() {
        let profileImageContainView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        profileImageContainView.addGestureRecognizer(UITapGestureRecognizer(target: viewModel, action: #selector(SpotFeedViewModel.profileButtonClicked)))
        let profileImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 34, height: 34))
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.layer.masksToBounds = true
        
        profileImageView.loadImageUsingCache(withUrl: userSession.user.profileImageUrl)
        
        profileImageContainView.addSubview(profileImageView)
        let rightBarButton = UIBarButtonItem(customView: profileImageContainView)
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
}

// STATE
extension MatchesViewController: MatchesViewModelDelegate {
    func nodsReceived(_ nodsReceived: [User]) {
        self.nods = nodsReceived
    }
    
    func noNodsReceived(_ noNodsReceived: Bool) {
        self.nods = []
    }
    
    func userSession(_ currentUserSession: UserSession) {
        
    }
    
    func noMatchedUsers(_ noMatchedUsers: Bool) {
        configureNoMatches()
    }
    
    func error(_ error: LHError) {
        print(error)
    }
    
    func matchedUsersReceived(_ matchedUsersReceived: [User]) {
        self.configureMatches()
        self.matches = matchedUsersReceived
    }
    
    func isFetchingUsers(_ isFetchingUsers: Bool) {
        if isFetchingUsers {
            self.revealingSplashView.backgroundColor = UIColor.lhPurple
            self.view.addSubview(self.revealingSplashView)
            self.revealingSplashView.animationType = SplashAnimationType.heartBeat
            self.revealingSplashView.startAnimation()
        } else {
            self.revealingSplashView.heartAttack = true
        }
    }
}

extension MatchesViewController {
    func configureNoMatches() {

    }
    
    func configureMatches() {

    }
}

extension MatchesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = data[indexPath.section][indexPath.row]
        self.viewModel.showProfileDetail?(user, .spotFeed)
    }
}

extension MatchesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = data[indexPath.section][indexPath.row]
        
        let cell = SpotFeedProfileTableViewCell()
        cell.featuredUser = user
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.tableView(tableView, numberOfRowsInSection: section) > 0 {
            return 40
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: UIView = UIView.init(frame: CGRect(x: 1, y: 50, width: 276, height: 30))
        headerView.backgroundColor = UIColor.init(hexString: "#31CAFF", alpha: 1.0)

        let labelView: UILabel = UILabel.init(frame: CGRect(x: 4, y: 5, width: 276, height: 24))
        labelView.font = UIFont(name: "AvenirNext-Bold", size: 20.0)
        labelView.textColor = .white

        switch section {
        case 0:
            labelView.text = "Nods"
        case 1:
            labelView.text = "Your Circle"
        default:
            fatalError()
        }
        
        headerView.addSubview(labelView)
        return headerView
    }
    
}
