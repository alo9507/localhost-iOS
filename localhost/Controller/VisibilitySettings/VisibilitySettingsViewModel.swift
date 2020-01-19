//
//  VisibilitySettingsViewModel.swift
//  Contact
//
//  Created by Andrew O'Brien on 9/14/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation
import RangeSeekSlider

class VisibilitySettingsViewModel: UserSessionStoreSubscriber {
    func userSessionUpdated(_ userSession: UserSession) {
        self.delegate?.userSession(userSession)
    }
    
    var currentUser: User {
        return UserSessionStore.shared.userSession.user
    }
    
    var userSession: UserSession {
        return UserSessionStore.shared.userSession
    }
    
    var delegate: VisibilitySettingsViewModelDelegate?
    
    var minAge: Int = UserSessionStore.shared.userSession.user.visibilitySettings.lowerAgeBound
    var maxAge: Int = UserSessionStore.shared.userSession.user.visibilitySettings.upperAgeBound
    var testLocation: TestLocation = UserSessionStore.shared.userSession.user.visibilitySettings.testSetting
    var sex: Sex = UserSessionStore.shared.userSession.user.visibilitySettings.sex
    
    let userRepo: UserRepository
    
    init(userRepo: UserRepository) {
        self.userRepo = userRepo
        
        UserSessionStore.subscribe(self)
    }
}

extension VisibilitySettingsViewModel {
    @objc
    func cancel() {
        delegate?.dismissSelf()
    }
    
    @objc
    func updateVisibilitySettings() {
        delegate?.dismissSelf()
        
        let updatedVisibilitySettings =
            VisibilitySettings(
                sex: sex,
                sexualOrientation: .all,
                lowerAgeBound: minAge,
                upperAgeBound: maxAge,
                testSetting: testLocation,
                blockedUsers: [],
                blockedBy: []
        )
        
//        userRepo.updateCurrentUser(
//        userUid: currentUser.uid,
//        data: ["visibilitySettings": updatedVisibilitySettings.documentData]) { (user, error) in
//            if error != nil { return print(error!.localizedDescription) }
//            guard let user = user else { return print(LHError.illegalState("Nil User : Nil Error")) }
//            print("Visibility Settings changed to: \(user.visibilitySettings)")
//        }
    }
    
    @objc
    func testUserLocationSet(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            testLocation = .techEvent
        case 1:
            testLocation = .eclecticCafe
        default:
            fatalError()
        }
    }
    
    @objc
    func sexControlSet(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            sex = .all
        case 1:
            sex = .female
        case 2:
            sex = .male
        default:
            fatalError()
        }
    }
}

extension VisibilitySettingsViewModel: RangeSeekSliderDelegate {
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        minAge = Int(minValue.rounded())
        maxAge = Int(maxValue.rounded())
    }
}

protocol VisibilitySettingsViewModelDelegate {
    func userSession(_ userSession: UserSession)
    func dismissSelf() -> Void
}
