//
//  TutorialPageViewController.swift
//  Contact
//
//  Created by Andrew O'Brien on 8/16/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation
import UIKit

class RegistrationPageViewController: DynamicPageViewController {
    
    let user: User
    
    init(user: User, orderedViewControllers: [UIViewController]) {
        self.user = user
        super.init(orderedViewControllers: orderedViewControllers)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
