//
//  AccountCoordinator.swift
//  Contact
//
//  Created by Andrew O'Brien on 1/11/20.
//  Copyright © 2020 Andrew O'Brien. All rights reserved.
//

import Foundation
import UIKit

class AccountCoordinator: Coordinator {
    
    private let presenter: UIViewController
    var accountViewController: AccountViewController = AppDelegate.appContainer.makeAccountViewController()
    
    init(presenter: UIViewController) {
        self.presenter = presenter
    }
    
    override func start() {
        self.accountViewController.viewModel.verifyUserWantsToLogout = {
            self.verifyUserWantsToLogout()
        }
        
        self.accountViewController.viewModel.verifyUserWantsToDeleteAccount = {
            self.verifyUserWantsToDeleteAccount()
        }
        self.accountViewController.viewModel.showAuthenticationScreen = {
            self.showAuthenticationScreen()
        }
        
        self.accountViewController.viewModel.showPromptForCredentials = {
            self.showPromptForCredentials()
        }
        
        accountViewController.modalPresentationStyle = .fullScreen
        
        presenter.present(self.accountViewController, animated: true, completion: nil)
    }
    
    func showPreferences() {
        let preferencesViewController = AppDelegate.appContainer.makePreferencesViewController()
        presenter.present(preferencesViewController, animated: true, completion: nil)
    }
    
    func showAccount() {
        let accountViewController = AppDelegate.appContainer.makeAccountViewController()
        presenter.present(accountViewController, animated: true, completion: nil)
    }
    
    func verifyUserWantsToLogout() {
        let alert = UIAlertController(title: "Logout?", message: "Are you sure you want to log out?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: { (action) in
            self.accountViewController.viewModel.signOut()
        }))
        
        self.accountViewController.present(alert, animated: true, completion: nil)
    }
    
    func showPromptForCredentials() {
        let credentialsAlertView = UIAlertController(title: "Enter Credentials", message: "Please enter your email and password", preferredStyle: .alert)

        credentialsAlertView.addTextField { (textField) in
            textField.placeholder = "Email"
        }

        credentialsAlertView.addTextField { (textField) in
            textField.placeholder = "Password"
        }
        
        credentialsAlertView.addAction(UIAlertAction(title: "Delete Account", style: .destructive, handler: { (action) in
            self.accountViewController.viewModel.signInToDeleteAccount(email: credentialsAlertView.textFields![0].text!, password: credentialsAlertView.textFields![1].text!)
        }))

        credentialsAlertView.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            credentialsAlertView.dismiss(animated: true, completion: nil)
        }))
        
        accountViewController.present(credentialsAlertView, animated: true, completion: nil)
    }
    
    func verifyUserWantsToDeleteAccount() {
        let alert = UIAlertController(title: "Delete Account?", message: "Are you sure you want to delete your account?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Never Mind", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes, Delete", style: .destructive, handler: { (action) in
            self.accountViewController.viewModel.deleteAccount()
        }))
        
        self.accountViewController.present(alert, animated: true, completion: nil)
    }
    
    func showAuthenticationScreen() {
        let authenticationCoordinator = AppDelegate.appContainer.makeAuthenticationCoordinator(presenter: presenter)
        authenticationCoordinator.start()
    }
}
