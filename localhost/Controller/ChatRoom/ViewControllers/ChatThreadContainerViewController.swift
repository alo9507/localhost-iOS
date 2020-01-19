//
//  ChatThreadContainerViewController.swift
//  Contact
//
//  Created by Andrew O'Brien on 1/19/20.
//  Copyright © 2020 Andrew O'Brien. All rights reserved.
//

import Foundation
import UIKit

final class ChatThreadContainerViewController: NiblessViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    let chatThreadViewController: ChatThreadViewController
    
    /// Required for the `MessageInputBar` to be visible
    override var canBecomeFirstResponder: Bool {
        return chatThreadViewController.canBecomeFirstResponder
    }
    
    /// Required for the `MessageInputBar` to be visible
    override var inputAccessoryView: UIView? {
        return chatThreadViewController.inputAccessoryView
    }
    
    init(chatThreadViewController: ChatThreadViewController) {
        self.chatThreadViewController = chatThreadViewController
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Add the `ConversationViewController` as a child view controller
        chatThreadViewController.willMove(toParent: self)
        addChild(chatThreadViewController)
        view.addSubview(chatThreadViewController.view)
        chatThreadViewController.didMove(toParent: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barTintColor = .clear
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isTranslucent = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let headerHeight: CGFloat = 200
        chatThreadViewController.view.frame = CGRect(x: 0, y: headerHeight, width: view.bounds.width, height: view.bounds.height - headerHeight)
    }
    
}
