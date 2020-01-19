//
//  MockSpotFeedViewModelDelegate.swift
//  localhostUnitTests
//
//  Created by Andrew O'Brien on 1/12/20.
//  Copyright © 2020 Andrew O'Brien. All rights reserved.
//
@testable import Contact

class MockSpotFeedViewModelDelegate: SpotFeedViewModelDelegate, TestResetable {
    
    var allLocalUsersCalledWith: [UserCategory] = []
    var visibleLocalUsersCalledWith: [UserCategory] = []
    var filteredUsersCalledWith: [UserCategory] = []
    
    var sexFilteredUsersCalledWith: [UserCategory] = []
    var schoolFilteredUsersCalledWith: [UserCategory] = []
    var noLocalUsersCalled: Bool = false
    var noFilteredUsersCalled = false
    var errorCalledWith: LHError = .failedToDoSomething("Unknown Error")
    var noVisibleLocalUsersCalled = false
    
    func userSession(_ userSession: UserSession) {
        
    }
    
    func isHosting(_ isHosting: Bool) {
        
    }
    
    func allLocalUsers(_ allLocalUsers: [UserCategory]) {
        allLocalUsersCalledWith = allLocalUsers
    }
    
    func visibleLocalUsers(_ visibleLocalUsers: [UserCategory]) {
        visibleLocalUsersCalledWith = visibleLocalUsers
    }
    
    func filteredLocalUsers(_ filteredLocalUsers: [UserCategory]) {
        filteredUsersCalledWith = filteredLocalUsers
    }
    
    func noLocalUsers() {
        noLocalUsersCalled = true
    }
    
    func noFilteredUsers() {
        noFilteredUsersCalled = true
    }
    
    func isFetchingUsers(_ isFetchingUsers: Bool) {
        
    }
    
    func sexFilteredUsers(_ sexFilteredUsers: [UserCategory]) {
        sexFilteredUsersCalledWith = sexFilteredUsers
    }
    
    func schoolFilteredUsers(_ schoolFilteredUsers: [UserCategory]) {
        schoolFilteredUsersCalledWith = schoolFilteredUsers
    }
    
    func error(_ error: LHError) {
        errorCalledWith = error
    }
    
    func noVisibleLocalUsers() {
        noVisibleLocalUsersCalled = true
    }
    
    func resetAll() {
        sexFilteredUsersCalledWith = []
        schoolFilteredUsersCalledWith = []
        allLocalUsersCalledWith = []
        visibleLocalUsersCalledWith = []
        noLocalUsersCalled = false
        noFilteredUsersCalled = false
        noVisibleLocalUsersCalled = false
    }
}
