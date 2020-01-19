//
//  YourCircleViewModel.swift
//  Contact
//
//  Created by Andrew O'Brien on 9/2/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation
import UIKit

protocol YourCircleViewModelDelegate: class {
    func userSession(_ userSession: UserSession) 
    func currentSelection(_ currentSelection: Int)
}

class YourCircleViewModel: UserSessionStoreSubscriber {
    func userSessionUpdated(_ userSession: UserSession) {
        self.delegate?.userSession(userSession)
    }
    
    weak var delegate: YourCircleViewModelDelegate? {
        didSet {
            delegate?.userSession(UserSessionStore.shared.userSession)
            delegate?.currentSelection(0)
        }
    }
    
    var currentUser: User {
        return UserSessionStore.shared.userSession.user
    }
    
    var userSession: UserSession {
       return UserSessionStore.shared.userSession
    }
    
    init() {
        UserSessionStore.subscribe(self)
    }
}

extension YourCircleViewModel {
    
    @objc
    func segmentedControlToggled(_ sender: Any) {
        let segment = sender as! UISegmentedControl
        
        switch segment.selectedSegmentIndex {
        case 0:
            self.delegate?.currentSelection(0)
        case 1:
            self.delegate?.currentSelection(1)
        case 2:
            self.delegate?.currentSelection(2)
        default:
            fatalError()
        }
    }
    
}
