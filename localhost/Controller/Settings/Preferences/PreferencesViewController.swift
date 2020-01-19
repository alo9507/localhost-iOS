//
//  PreferencesViewController.swift
//  Contact
//
//  Created by Andrew O'Brien on 1/10/20.
//  Copyright © 2020 Andrew O'Brien. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class PreferencesViewController: NiblessViewController {
    let options = ["Show My", "Visibility Settings"]
    
    lazy var preferencesTableView: UITableView = {
        let preferencesTableView = UITableView()
        preferencesTableView.register(CustomTableCell.self, forCellReuseIdentifier: "cellId")
        preferencesTableView.backgroundColor = .clear
        preferencesTableView.separatorStyle = .none
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
    
    lazy var preferencesLabel: UILabel = {
        let preferencesLabel = UILabel()
        preferencesLabel.font = Fonts.avenirNext_bold(50)
        preferencesLabel.textColor = .white
        preferencesLabel.text = "Preferences"
        preferencesLabel.textAlignment = .left
        preferencesLabel.numberOfLines = 0
        preferencesLabel.textColor = .white
        return preferencesLabel
    }()
    
    let viewModel: PreferencesViewModel
    
    init(viewModel: PreferencesViewModel) {
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

extension PreferencesViewController {
    func constructHierarchy() {
        view.addSubview(preferencesLabel)
        view.addSubview(exitButton)
        view.addSubview(preferencesTableView)
    }
    
    func activateConstraints() {
        preferencesLabel.snp.makeConstraints { (make) in
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
        
        preferencesTableView.snp.makeConstraints { (make) in
            make.top.equalTo(preferencesLabel.snp.bottom).offset(10)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.left.right.equalToSuperview()
        }
    }
}

// MARK: SettingsTableViewDataSource
extension PreferencesViewController: UITableViewDataSource {
    
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
extension PreferencesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        preferencesTableView.deselectRow(at: indexPath, animated: false)
        
        switch indexPath.row {
        case 0:
            viewModel.showShowMy?()
        case 1:
            viewModel.showVisibilitySettings?()
        default:
            return
        }
    }
}

extension PreferencesViewController: PreferencesViewModelDelegate {
    func logoutSuccessful() {
        
    }
    
    func errorLoggingOut(error: Error) {
        
    }
}
