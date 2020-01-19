//
//  SpotFeedView.swift
//  Contact
//
//  Created by Andrew O'Brien on 12/30/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation
import UIKit
import RevealingSplashView

class SpotFeedView: NiblessView {
    
    var viewModel: SpotFeedViewModel
    
    init(viewModel: SpotFeedViewModel) {
        self.viewModel = viewModel
        
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        setupUI()
    }
    
    // MARK: BLANK STATES
    // NO LOCAL USERS
    var noLocalUsers: UILabel = {
        let noLocalUsers = UILabel(frame: .zero)
        noLocalUsers.font = UIFont(name: "AvenirNext-Bold", size: 20.0)
        noLocalUsers.textAlignment = .center
        noLocalUsers.numberOfLines = 3
        noLocalUsers.textColor = UIColor.white
        noLocalUsers.text = "Be Proud! You're the first person on localhost in your area."
        noLocalUsers.isHidden = true
        return noLocalUsers
    }()
    
    // NO VISIBLE LOCAL USERS
    var noVisibleLocalUsers: UILabel = {
        let noVisibleLocalUsers = UILabel(frame: .zero)
        noVisibleLocalUsers.font = UIFont(name: "AvenirNext-Bold", size: 20.0)
        noVisibleLocalUsers.textAlignment = .center
        noVisibleLocalUsers.numberOfLines = 3
        noVisibleLocalUsers.textColor = UIColor.white
        noVisibleLocalUsers.text = "Local users exist, but they're all set to invisble at the moment"
        noVisibleLocalUsers.isHidden = true
        return noVisibleLocalUsers
    }()
    
    // NO FILTERED USERS (i.e., visible local users exist, but your filters exclude them)
    var noFilteredUsersLabel: UILabel = {
        let noFilteredUsersLabel = UILabel(frame: .zero)
        noFilteredUsersLabel.font = UIFont(name: "AvenirNext-Bold", size: 20.0)
        noFilteredUsersLabel.textAlignment = .center
        noFilteredUsersLabel.numberOfLines = 3
        noFilteredUsersLabel.textColor = UIColor.white
        noFilteredUsersLabel.text = "No local users match that criteria. Open your mind!"
        noFilteredUsersLabel.isHidden = true
        return noFilteredUsersLabel
    }()
    
    // NOT HOSTING
    var youAreInvisibleLabel: UILabel = {
        let youAreInvisibleLabel = UILabel(frame: .zero)
        youAreInvisibleLabel.font = UIFont(name: "AvenirNext-Bold", size: 35.0)
        youAreInvisibleLabel.textAlignment = .center
        youAreInvisibleLabel.numberOfLines = 0
        youAreInvisibleLabel.textColor = UIColor.white
        youAreInvisibleLabel.text = "You are Invisible"
        youAreInvisibleLabel.isHidden = true
        youAreInvisibleLabel.sizeToFit()
        return youAreInvisibleLabel
    }()
    
    var isNotHostingLabel: UILabel = {
        let isNotHostingLabel = UILabel(frame: .zero)
        isNotHostingLabel.font = UIFont(name: "AvenirNext-Bold", size: 28.0)
        isNotHostingLabel.textAlignment = .center
        isNotHostingLabel.numberOfLines = 0
        isNotHostingLabel.textColor = UIColor.white
        isNotHostingLabel.text = "Start hosting to connect with local users"
        isNotHostingLabel.isHidden = true
        isNotHostingLabel.sizeToFit()
        return isNotHostingLabel
    }()
    
    lazy var isNotHostingImageView: UIImageView = {
        let imageName = "noBGwifiPng"
        let image = UIImage(named: imageName)
        let isNotHostingImageView = UIImageView(image: image!)
        isNotHostingImageView.contentMode = .scaleAspectFit
        isNotHostingImageView.isHidden = true
        isNotHostingImageView.isUserInteractionEnabled = true
        isNotHostingImageView.addGestureRecognizer(UITapGestureRecognizer(target: viewModel, action: #selector(SpotFeedViewModel.toggleHostingButtonPressed)))
        return isNotHostingImageView
    }()
    
    lazy var headerView: UIView = {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.lhPurple
        return headerView
    }()
    
    lazy var statusTextField: PaddedTextField = {
        let statusTextField = PaddedTextField()
        statusTextField.placeholder = "What are you up to right now?"
        statusTextField.backgroundColor = .white
        statusTextField.layer.cornerRadius = 20.0
        statusTextField.layer.borderWidth = 1.5
        statusTextField.layer.borderColor = UIColor.lhTurquoise.cgColor
        statusTextField.font = UIFont(name: "AvenirNext-Regular", size: 16)
        
        let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        statusTextField.addGestureRecognizer(UITapGestureRecognizer(target: viewModel, action: #selector(SpotFeedViewModel.editStatusTapped)))
        
        return statusTextField
    }()
    
    lazy var profileImageView: UIImageView = {
        let profileImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 45, height: 45))
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.layer.masksToBounds = true
        
        let userSession = UserSessionStore.shared.userSession
        
        profileImageView.loadImageUsingCache(withUrl: userSession.user.profileImageUrl)
        
        profileImageView.isUserInteractionEnabled = true
        
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: viewModel, action: #selector(SpotFeedViewModel.profileButtonClicked)))
        
        return profileImageView
    }()
    
    lazy var filterImageView: UIImageView = {
        let filterImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 34, height: 34))
        filterImageView.contentMode = .scaleAspectFit
        filterImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        filterImageView.layer.masksToBounds = true
        filterImageView.image = UIImage(named: "filter")
        filterImageView.isUserInteractionEnabled = true
        
        filterImageView.addGestureRecognizer(UITapGestureRecognizer(target: viewModel, action: #selector(SpotFeedViewModel.filterPressed)))
        
        return filterImageView
    }()
    
    var revealingSplashView: RevealingSplashView = {
        let revealingSplashView = RevealingSplashView(iconImage: UIImage(named: "LocalhostAppIconRound")!, iconInitialSize: CGSize(width: 80, height: 80), backgroundColor: UIColor.white)
        return revealingSplashView
    }()
}

extension SpotFeedView {
    func setupUI() {
        constructHierarchy()
        activateConstraints()
    }
    
    func constructHierarchy() {
        addSubview(headerView)
        headerView.addSubview(statusTextField)
        headerView.addSubview(profileImageView)
        headerView.addSubview(filterImageView)
        addSubview(isNotHostingLabel)
        addSubview(noLocalUsers)
        addSubview(noFilteredUsersLabel)
        addSubview(youAreInvisibleLabel)
        addSubview(isNotHostingImageView)
        addSubview(noVisibleLocalUsers)
    }
    
    func activateConstraints() {
        activateHeaderViewConstratints()
        activateStatusTextFieldConstratints()
        activateProfileImageViewConstratints()
        activateFilterImageViewConstratints()
        
        // BLANK STATES
        
        // NOT HOSTING
        activateIsNotHostingImageViewConstraints()
        activateYouAreInvisibleLabelConstraints()
        activateIsNotHostingLabelConstraints()
        
        // NO LOCAL USERS
        activateNoLocalUsersLabelConstraints()
        
        // NO VISIBLE LOCAL USERS
        activateNoVisibleLocalUsersLabelConstraints()
        
        // NO FILTERED USERS
        activateNoFilteredUsersLabelConstraints()
    }
    
    func activateHeaderViewConstratints() {
        headerView.snp.makeConstraints { (make) in
            make.height.equalTo(115)
            make.width.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(3)
        }
    }
    
    func activateProfileImageViewConstratints() {
        profileImageView.snp.makeConstraints { (make) in
            make.height.width.equalTo(45)
            make.left.equalToSuperview().inset(10)
            make.top.equalToSuperview().offset(20)
        }
    }
    
    func activateStatusTextFieldConstratints() {
        statusTextField.snp.makeConstraints { (make) in
            make.height.equalTo(40)
            make.left.equalTo(profileImageView.snp.right).offset(7)
            make.right.equalToSuperview().inset(10)
            make.centerY.equalTo(profileImageView.snp.centerY)
        }
    }
    
    func activateFilterImageViewConstratints() {
        filterImageView.snp.makeConstraints { (make) in
            make.height.width.equalTo(35)
            make.top.equalTo(profileImageView.snp.bottom).offset(12)
            make.right.equalToSuperview().offset(-10)
        }
    }
    
    func activateIsNotHostingImageViewConstraints() {
        isNotHostingImageView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(300)
        }
    }
    
    func activateYouAreInvisibleLabelConstraints() {
        youAreInvisibleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(isNotHostingImageView.snp.top).offset(-20)
            make.width.equalToSuperview().inset(5)
        }
    }
    
    func activateIsNotHostingLabelConstraints() {
        isNotHostingLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(isNotHostingImageView.snp.bottom).offset(20)
            make.width.equalToSuperview().inset(5)
        }
    }
    
    func activateNoLocalUsersLabelConstraints() {
        noLocalUsers.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.center.equalToSuperview()
        }
    }
    
    func activateNoVisibleLocalUsersLabelConstraints() {
        noLocalUsers.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.center.equalToSuperview()
        }
    }
    
    func activateNoFilteredUsersLabelConstraints() {
        noFilteredUsersLabel.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.center.equalToSuperview()
        }
    }
}
