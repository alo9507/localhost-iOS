//
//  ChangeProfileViewController.swift
//  Contact
//
//  Created by Andrew O'Brien on 1/11/20.
//  Copyright © 2020 Andrew O'Brien. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class ChangeProfileViewController: NiblessViewController {
    let viewModel: ChangeProfileViewModel
    
    let editProfileViewController: EditProfileViewController
    let previewProfileViewController: PreviewProfileViewController
    
    init(viewModel: ChangeProfileViewModel) {
        self.viewModel = viewModel
        self.editProfileViewController = AppDelegate.appContainer.makeEditProfileViewController(UserSessionStore.user)
        // how to propogate editedUser changes to PreviewVC without re-instantiating
        self.previewProfileViewController = AppDelegate.appContainer.makePreviewProfileViewController(viewModel.editedUser, .myProfile)
        super.init()
        self.viewModel.delegate = self
        view.backgroundColor = UIColor.lhPurple
        configureNavBar()
        constructHierarchy()
        activateConstraints()
        
        let rightSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        rightSwipeGestureRecognizer.direction = .right

        let leftSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        leftSwipeGestureRecognizer.direction = .left

        view.addGestureRecognizer(rightSwipeGestureRecognizer)
        view.addGestureRecognizer(leftSwipeGestureRecognizer)

    }
    
    @objc
    func handleSwipes(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .right {
            self.changeProfileSegmentedControl.selectedSegmentIndex = 0
        } else {
            self.changeProfileSegmentedControl.selectedSegmentIndex = 1
        }
        self.segmentedControlToggled(changeProfileSegmentedControl)
    }
    
    lazy var changeProfileSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Edit", "Preview"])
        
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
        segmentedControl.addTarget(self, action: #selector(segmentedControlToggled(_:)), for: .valueChanged)
        return segmentedControl
    }()
    
    @objc
    func segmentedControlToggled(_ sender: Any) {
        let segment = sender as! UISegmentedControl
        
        switch segment.selectedSegmentIndex {
        case 0:
            editProfileViewController.view.isHidden = false
            previewProfileViewController.view.isHidden = true
//            UIView.animate(withDuration: 0.25) {
//                return
//            }
        case 1:
            editProfileViewController.view.isHidden = true
            previewProfileViewController.view.isHidden = false
//            UIView.animate(withDuration: 0.25) {
//                self.editProfileViewController.view.snp.updateConstraints { (make) in
//                    make.left.equalToSuperview().offset(-UIScreen.main.bounds.width)
//                }
//                self.previewProfileViewController.view.snp.updateConstraints { (make) in
//                    make.left.equalToSuperview()
//                }
//                self.view.layoutIfNeeded()
//            }
        default:
            fatalError()
        }
    }
}

extension ChangeProfileViewController {
    func constructHierarchy() {
        self.navigationItem.titleView = changeProfileSegmentedControl
        
        self.view.addSubview(editProfileViewController.view)
        addChild(editProfileViewController)
        editProfileViewController.didMove(toParent: parent)
        editProfileViewController.view.isHidden = false
        
        self.view.addSubview(previewProfileViewController.view)
        addChild(previewProfileViewController)
        previewProfileViewController.didMove(toParent: parent)
        previewProfileViewController.view.isHidden = true
    }
    
    func activateConstraints() {
        editProfileViewController.view.snp.makeConstraints { (make) in
            make.bottom.top.left.right.equalToSuperview()
        }
        
        previewProfileViewController.view.snp.makeConstraints { (make) in
            make.bottom.top.left.right.equalToSuperview()
        }
    }
}

extension ChangeProfileViewController {
    func configureNavBar() {
        self.title = UserSessionStore.user.firstName
        
        let rightBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItem.Style.plain, target: viewModel, action: #selector(EditProfileViewModel.updateUserProfile))
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont(name: "AvenirNext-Bold", size: 19.0)!,
            NSAttributedString.Key.foregroundColor: UIColor.white
        ], for: .normal)
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont(name: "AvenirNext-Bold", size: 19.0)!,
            NSAttributedString.Key.foregroundColor: UIColor.white
        ], for: .selected)
        
        let leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: viewModel, action: #selector(ChangeProfileViewModel.cancel))
        navigationItem.leftBarButtonItem = leftBarButtonItem
        
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont(name: "AvenirNext-Regular", size: 19.0)!,
            NSAttributedString.Key.foregroundColor: UIColor.white
        ], for: .normal)
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont(name: "AvenirNext-Regular", size: 19.0)!,
            NSAttributedString.Key.foregroundColor: UIColor.white
        ], for: .selected)
    }
}

extension ChangeProfileViewController: ChangeProfileViewModelDelegate {
    func userSession(_ userSession: UserSession) {
        
    }
    
    func dismissSelf() {
        self.dismiss(animated: true)
    }
}
