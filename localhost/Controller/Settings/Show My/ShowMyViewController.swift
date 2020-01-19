//
//  ShowMyViewController.swift
//  Contact
//
//  Created by Andrew O'Brien on 12/27/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation
import UIKit

class ShowMyViewController: NiblessViewController {
    let showMyTableView: UITableView = {
        let showMyTableView = UITableView()
        showMyTableView.allowsMultipleSelection = true
        showMyTableView.register(ShowMyCell.self, forCellReuseIdentifier: "cellId")
        showMyTableView.backgroundColor = .clear
        showMyTableView.separatorStyle = .none
        showMyTableView.allowsSelectionDuringEditing = true
        return showMyTableView
    }()
    
    var showMyOptions: [String] = [
        "Name",
        "Age",
        "Education",
        "Affiliations",
        "Sex",
        "Profile Picture",
        "Conversation Topics",
        "Skills",
        "Sexual Preference",
        "Hometown",
        "Marital Status"
    ]
    
    var selectedShowMyOptions: [String] = []
    
    lazy var saveButton: UIButton = {
        let saveButton = UIButton()
        saveButton.setTitle("SAVE", for: .normal)
        saveButton.addTarget(viewModel, action: #selector(ShowMyViewModel.save), for: .touchUpInside)
        saveButton.backgroundColor = .blue
        return saveButton
    }()
    
    var viewModel: ShowMyViewModel
    var userSession: UserSession {
        return UserSessionStore.shared.userSession
    }
    
    init(viewModel: ShowMyViewModel) {
        self.viewModel = viewModel
        super.init()
        viewModel.delegate = self
    }
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.lhPurple
        showMyTableView.dataSource = self
        showMyTableView.delegate = self
        render()
    }
    
    deinit {
        UserSessionStore.unsubscribe(viewModel)
    }
}

extension ShowMyViewController {
    func render() {
        view.addSubview(showMyTableView)
        view.addSubview(saveButton)
        
        showMyTableView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(700)
        }
        
        saveButton.snp.makeConstraints { (make) in
            make.top.equalTo(showMyTableView.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(15)
            make.height.equalTo(50)
        }
    }
}

extension ShowMyViewController: ShowMyViewModelDelegate {
    func userSession(_ userSession: UserSession) {
        
    }
    
    func dismissSelf() {
        self.dismiss(animated: true)
    }
}


// MARK: SettingsTableViewDataSource
extension ShowMyViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showMyOptions.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let showMyOptionText = showMyOptions[indexPath.row]
        let isSelected = userSession.user.showMy.contains(showMyOptions[indexPath.row])
        
        let cell = ShowMyCell()
        cell.showMyOption.text = showMyOptionText
        cell.showThisOption = isSelected
        
        if isSelected {
            showMyTableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            viewModel.showMySelections.append(showMyOptions[indexPath.row])
        }
        
        return cell
    }
}

// MARK: UITableViewDelegate
extension ShowMyViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.showMySelections.append(showMyOptions[indexPath.row])
        
        guard let cell = tableView.cellForRow(at: indexPath) as? ShowMyCell else {
            fatalError("ShowMyOptions doesn't contain that cell")
        }
        cell.showThisOption = true
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let deselection = showMyOptions[indexPath.row]
        
        while let idx = viewModel.showMySelections.firstIndex(of: deselection) {
            viewModel.showMySelections.remove(at: idx)
        }
        
        guard let cell = tableView.cellForRow(at: indexPath) as? ShowMyCell else {
            fatalError("ShowMyOptions doesn't contain that cell")
        }
        
        cell.showThisOption = false
    }
}
