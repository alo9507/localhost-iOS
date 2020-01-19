//
//  UIViewController.swift
//  Contact
//
//  Created by Andrew O'Brien on 9/4/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func findTabBarController() -> UITabBarController? {
        if let nextResponder = self.next as? UITabBarController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findTabBarController()
        } else if let nextResponder = self.next as? UIViewController {
            return nextResponder.findTabBarController()
        } else {
            return nil
        }
    }
    
    func findNavigationController() -> UINavigationController? {
        if let nextResponder = self.next as? UINavigationController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findNavigationController()
        } else if let nextResponder = self.next as? UIViewController {
            return nextResponder.findNavigationController()
        } else {
            return nil
        }
    }
}
