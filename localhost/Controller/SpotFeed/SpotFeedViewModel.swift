//
//  AuthenticationViewModel.swift
//  Contact
//
//  Created by Andrew O'Brien on 8/12/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit
import GeoFire
import FirebaseFirestore

protocol SpotFeedViewModelDelegate: class {
    func userSession(_ userSession: UserSession)
    func isHosting(_ isHosting: Bool)
    func noLocalUsers()
    func noFilteredUsers()
    func noVisibleLocalUsers()
    func isFetchingUsers(_ isFetchingUsers: Bool)
    func allLocalUsers(_ allLocalUsers: [UserCategory])
    func visibleLocalUsers(_ visibleLocalUsers: [UserCategory])
    func filteredLocalUsers(_ filteredLocalUsers: [UserCategory])
    func sexFilteredUsers(_ sexFilteredUsers: [UserCategory])
    func schoolFilteredUsers(_ schoolFilteredUsers: [UserCategory])
    func error(_ error: LHError)
}

enum FilterCategory {
    case sex
    case school
    case profession
}

public class SpotFeedViewModel: NSObject, UserSessionStoreSubscriber {
    func userSessionUpdated(_ userSession: UserSession) {
        let storedVisSettings = userSession.user.visibilitySettings
        let visibilitySettingsChanged = userSession.user.visibilitySettings != storedVisSettings
        
        self.userSession = userSession
        self.delegate?.userSession(userSession)
        if (visibilitySettingsChanged) {
            self.fetchLocalUsers()
        }
    }
    
    var userSession: UserSession
    let userRepository: UserRepository
    let locationManager: CLLocationManager
    var userSessionRepository: UserSessionRepository
    
    var showEditStatus: (() -> Void)?
    var showProfileDetail: ((User, Origin) -> Void)?
    var showVisibilitySettings: (() -> Void)?
    
    var filtersActivated = false
    
    init(
        userRepository: UserRepository,
        locationManager: CLLocationManager,
        userSessionRepository: UserSessionRepository
        ) {
        self.userRepository = userRepository
        self.locationManager = locationManager
        self.userSessionRepository = userSessionRepository
        self.userSession = UserSessionStore.shared.userSession
        
        super.init()
        UserSessionStore.subscribe(self)
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }
    
    /// Testing Initializer
    /// - Parameter userSession: Mock UserSession
    init(userSession: UserSession, userRepository: UserRepository) {
        self.userSession = userSession
        self.userRepository = userRepository
        self.locationManager = MockLocationManager()
        self.userSessionRepository = MockUserSessionRepository()
    }
    
    // MARK: - User Buckets
    var allLocalUsers: [User] = []
    
    var visibleLocalUsers: [UserCategory] {
        let allLocalUsers = self.allLocalUsers.filter { (user) -> Bool in
            return user.isVisible == true
        }
        
        let allVisibleLocalUsersCategory = [UserCategory(title: "All Visible Local Users", users: allLocalUsers)]
        return allVisibleLocalUsersCategory
    }
    
    var filteredLocalUsers: [UserCategory] {
        let filteredVisibleLocalUsers = self.visibleLocalUsers[0].users.filter({ (user) -> Bool in
            self.userSession.user
                .visibilitySettings
                .filter(
                    self.userSession.user,
                    user,
                    filters: [
                        .isNotCurrentUser,
                        .isVisible,
                        .isInAgeRange,
                        .isSex,
                        .currentUserPassesOtherUsersCriteria
                    ],
                    reciprocalCheck: true)
        })
        
        let filteredVisibleLocalUsersCategory = [UserCategory(title: "Filtered Users", users: filteredVisibleLocalUsers)]
        return filteredVisibleLocalUsersCategory
    }
    
    var sexFilteredUsers: [UserCategory] {
        return UserCategorizer.categorize(self.visibleLocalUsers[0].users, .sex)
    }
    
    var schoolFilteredUsers: [UserCategory] {
        return UserCategorizer.categorize(self.visibleLocalUsers[0].users, .school)
    }
    
    weak var delegate: SpotFeedViewModelDelegate? {
        didSet {
            delegate?.userSession(self.userSession)
        }
    }
}

// MARK: STARTUP METHODS
extension SpotFeedViewModel {
    public func fetchLocalUsers() {
        self.delegate?.isFetchingUsers(true)
        userRepository.getLocalUsers(currentUser: userSession.user) { (localUsers, error) in
            if error != nil {
                self.delegate?.error(LHError.failedToFetchLocalUsers(error!.localizedDescription))
                return
            }
            guard let localUsers = localUsers else { return print(LHError.illegalState("Nil Local Users : Nil Error")) }
            
            self.allLocalUsers = localUsers.filter({ (user) -> Bool in
                return user.uid != self.userSession.user.uid
            })
            
            self.delegate?.isFetchingUsers(false)
            
            if self.allLocalUsers.isEmpty {
                self.delegate?.noLocalUsers()
                return
            } else {
                let allLocalUsersCategory = [UserCategory(title: "All Local Users", users: self.allLocalUsers)]
                self.delegate?.allLocalUsers(allLocalUsersCategory)
                if self.visibleLocalUsers[0].users.isEmpty {
                    self.delegate?.noVisibleLocalUsers()
                    return
                } else {
                    self.delegate?.visibleLocalUsers(self.visibleLocalUsers)
                    if self.filteredLocalUsers[0].users.isEmpty {
                        self.delegate?.noFilteredUsers()
                        return
                    } else {
                        self.delegate?.filteredLocalUsers(self.filteredLocalUsers)
                    }
                }
            }
            
            if self.filtersActivated {
                self.delegate?.sexFilteredUsers(self.sexFilteredUsers)
                self.delegate?.schoolFilteredUsers(self.schoolFilteredUsers)
            }
        }
    }
}


// MARK: TASK METHODS
extension SpotFeedViewModel {
    
    @objc
    func toggleHostingButtonPressed() {
        self.delegate?.isHosting(self.userSession.user.isVisible)
        
        userSessionRepository.updateUserSession(data: ["isVisible":!self.userSession.user.isVisible]) { (userSession, error) in
            if error != nil { return (self.delegate?.error(LHError.failedToDoSomething("Failure")))! }
        }
    }
    
    @objc
    func filterPressed() {
        self.showVisibilitySettings?()
    }
    
    public func sendToProfileDetail(user: User) {
        self.showProfileDetail?(user, .spotFeed)
    }
    
    @objc
    func profileButtonClicked(_ sender: Any) {
        self.showProfileDetail?(userSession.user, .myProfile)
    }
    
    @objc
    func editStatusTapped(_ sender: Any) {
        self.showEditStatus?()
    }
}

// MARK: Location Manager
extension SpotFeedViewModel: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            
            locationManager.stopUpdatingLocation()
            
            print("LOCATION: longitude = \(location.coordinate.longitude), latitude = \(location.coordinate.latitude)")
            
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            
            print("Will update location for \(self.userSession.user.firstName) updated")
            
            guard let geohash = GFGeoHash(location: center).geoHashValue else {
                fatalError("Failed to convert to geohashed value")
            }
            
            let locationData: [String: Any] = ["location": GeoPoint(latitude: center.latitude, longitude: center.longitude), "geohash": geohash]
            
            userSessionRepository.updateUserSession(data: locationData) { (userSession, error) in
                if error != nil { return print("Failed to update with error: \(error!)") }
                guard let userSession = userSession else { return print(LHError.illegalState("Nil User : Nil Error")) }
                print("Location for \(userSession.user.firstName) updated")
            }
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("LOCATION ERROR: \(error)")
    }
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .notDetermined:
            print("AUTH STATUS: .notDetermined")
            locationManager.requestAlwaysAuthorization()
            break
        case .authorizedWhenInUse:
            print("AUTH STATUS: .authorizedWhenInUse")
            locationManager.startUpdatingLocation()
            break
        case .authorizedAlways:
            print("AUTH STATUS: .authorizedAlways")
            locationManager.startUpdatingLocation()
            break
        case .restricted:
            print("AUTH STATUS: .restricted")
            break
        case .denied:
            print("AUTH STATUS: .denied")
            break
        default:
            break
        }
    }
}
