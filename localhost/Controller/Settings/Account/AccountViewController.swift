//
//  AccountViewController.swift
//  Contact
//
//  Created by Andrew O'Brien on 1/10/20.
//  Copyright © 2020 Andrew O'Brien. All rights reserved.
//

import Foundation
import UIKit

class AccountViewController: NiblessViewController {
    
    let allSections = [["Phone Number","Email"],["Push Notifications"],["Privacy Policy","Cookies Policy"],["Member Principles"], ["Log Out", "Delete Account"]]
    
    lazy var accountTableView: UITableView = {
        let preferencesTableView = UITableView()
        preferencesTableView.register(CustomTableCell.self, forCellReuseIdentifier: "cellId")
        preferencesTableView.backgroundColor = .clear
        preferencesTableView.separatorStyle = .singleLine
        preferencesTableView.delegate = self
        preferencesTableView.dataSource = self
        return preferencesTableView
    }()
    
    lazy var exitButton: UIButton = {
        let exitButton = UIButton()
        exitButton.addTarget(self, action: #selector(dismissSelf), for: .touchUpInside)
        exitButton.setTitle("X", for: .normal)
        return exitButton
    }()
    
    lazy var accountLabel: UILabel = {
        let preferencesLabel = UILabel()
        preferencesLabel.font = Fonts.avenirNext_bold(50)
        preferencesLabel.textColor = .white
        preferencesLabel.text = "Account"
        preferencesLabel.textAlignment = .left
        preferencesLabel.numberOfLines = 0
        preferencesLabel.textColor = .white
        return preferencesLabel
    }()
    
    let viewModel: AccountViewModel
    
    init(viewModel: AccountViewModel) {
        self.viewModel = viewModel
        super.init()
        viewModel.delegate = self
        constructHierarchy()
        activateConstraints()
        self.view.backgroundColor = UIColor.lhPurple
    }
    
    @objc
    func dismissSelf(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension AccountViewController {
    func constructHierarchy() {
        view.addSubview(accountLabel)
        view.addSubview(exitButton)
        view.addSubview(accountTableView)
    }
    
    func activateConstraints() {
        accountLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(80)
            make.left.equalToSuperview().inset(10)
            make.right.equalTo(exitButton.snp.left)
        }
        
        exitButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(80)
            make.right.equalToSuperview().inset(10)
            make.width.height.equalTo(50)
            make.left.equalTo(exitButton.snp.right)
        }
        
        accountTableView.snp.makeConstraints { (make) in
            make.top.equalTo(accountLabel.snp.bottom).offset(10)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.left.right.equalToSuperview()
        }
    }
}

// MARK: SettingsTableViewDataSource
extension AccountViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allSections[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return allSections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! CustomTableCell
        cell.textLabel?.text = allSections[indexPath.section][indexPath.row]
        cell.textLabel?.font = UIFont(name: "AvenirNext-Bold", size: 20.0)!
        cell.textLabel?.textColor = .white
        
        if indexPath.section == 4 {
            cell.textLabel?.textAlignment = .center
            if indexPath.row == 1 {
                cell.textLabel?.textColor = .red
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 20))
        let label = UILabel(frame: CGRect(x: 10, y: 5, width: tableView.frame.size.width, height: 18))
        label.font = Fonts.avenirNext_bold(22)
        
        var titleText = ""
        switch section {
            case 0: titleText = "Phone & Email"
            case 1: titleText = "Notifications"
            case 2: titleText = "Legal"
            case 3: titleText = "Community"
            case 4: titleText = ""
            default: titleText = "Other"
        }
        
        label.text = titleText
        label.textColor = UIColor.lhTurquoise
        view.addSubview(label)
        view.backgroundColor = UIColor.clear

        label.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(18)
            make.bottom.equalToSuperview()
        }
        
        return view
    }
}

// MARK: UITableViewDelegate
extension AccountViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        accountTableView.deselectRow(at: indexPath, animated: false)
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
                case 0: return
                default: return
            }
        case 4:
            switch indexPath.row {
                case 0: self.viewModel.verifyUserWantsToLogout?()
            case 1: self.viewModel.verifyUserWantsToDeleteAccount?()
                default: return
            }
        default: return
        }
        
        switch indexPath.row {
        case 0:
            return
        case 1:
            return
        case 2:
            return
        default:
            return
        }
    }
}

extension AccountViewController: AccountViewModelDelegate {
    func logoutSuccessful() {
        self.dismiss(animated: true) {
            self.viewModel.showAuthenticationScreen?()
        }
    }
    
    func errorLoggingOut(error: Error) {
        
    }
    
    func credentialsRequiredToDeleteAccount() {
        self.viewModel.showPromptForCredentials?()
    }
    
    func deleteAccountSuccessful() {
        self.dismiss(animated: true) {
            self.viewModel.showAuthenticationScreen?()
        }
    }
}
