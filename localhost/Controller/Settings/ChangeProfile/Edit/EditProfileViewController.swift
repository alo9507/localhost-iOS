//
//  EditProfileViewController.swift
//  Contact
//
//  Created by Andrew O'Brien on 1/11/20.
//  Copyright © 2020 Andrew O'Brien. All rights reserved.
//

import Foundation
import UIKit

class EditProfileViewController: NiblessViewController {
    let viewModel: EditProfileViewModel
    
    init(viewModel: EditProfileViewModel) {
        self.viewModel = viewModel
        super.init()
        self.viewModel.delegate = self
        view.backgroundColor = UIColor.lhPurple
        constructHierarchy()
        activateConstraints()
    }
}

extension EditProfileViewController {
    func constructHierarchy() {}
    func activateConstraints() {}
}

extension EditProfileViewController: EditProfileViewModelDelegate {
    func userSession(_ userSession: UserSession) {
        
    }
    
    func dismissSelf() {
        self.dismiss(animated: true)
    }
}
