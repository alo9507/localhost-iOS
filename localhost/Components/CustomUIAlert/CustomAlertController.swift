//
//  CustomAlertController.swift
//  Contact
//
//  Created by Andrew O'Brien on 11/19/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class CustomAlertController: NiblessViewController {
    let alertPayload: AlertPayload
    
    init(alertPayload: AlertPayload) {
        self.alertPayload = alertPayload
//        render()
        super.init()
    }
    
//    func render() {
//        constructHierarchy()
//        activateConstraints()
//    }
//
//    @objc cancelButtonTapped() {
//
//    }
}
