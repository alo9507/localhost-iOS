//
//  SpotFeedViewModelTest.swift
//  localhostUnitTests
//
//  Created by Andrew O'Brien on 1/12/20.
//  Copyright © 2020 Andrew O'Brien. All rights reserved.
//

import Foundation
import Quick
import Nimble

@testable import Contact

class SpotFeedViewModelTests: QuickSpec {
    override func spec() {
        let mockUserSession: UserSession = {
            let mockUser = User(jsonDict: [:])
            mockUser.firstName = "CurrentUser"
            mockUser.uid = "MOCK_USER_ID"

            let mockAuthSession = LHAuthSession(token: "MOCK_AUTH_TOKEN", refreshToken: "", uid: mockUser.uid)
            return UserSession(user: mockUser, authSession: mockAuthSession)
        }()
        let mockUserRepository = MockUsersRepo()
        
        let spotFeedViewModel = SpotFeedViewModel(userSession: mockUserSession, userRepository: mockUserRepository)
        let mockSpotFeedViewModelDelegate = MockSpotFeedViewModelDelegate()
        spotFeedViewModel.delegate = mockSpotFeedViewModelDelegate
        
        describe("SpotFeedViewModelTests") {
            
            it("should have the correct mock userSession") {
                expect(spotFeedViewModel.userSession.user.uid).to(equal("MOCK_USER_ID"))
            }
            
            context("User Fetching") {
                let female_umich = User(jsonDict: [:])
                female_umich.sex = .female
                female_umich.uid = "female_umich"
                female_umich.education.append(Education(school: "University of Michigan - Ann Arbor", degree: .ba, major: "", minor: "", graduationYear: ""))
                female_umich.isVisible = true
                
                let male_georgetown = User(jsonDict: [:])
                male_georgetown.sex = .male
                male_georgetown.uid = "male_georgetown"
                male_georgetown.education.append(Education(school: "Georgetown University", degree: .ba, major: "", minor: "", graduationYear: ""))
                male_georgetown.isVisible = true
                
                let localUsers = [UserCategory(title: "All Local Users", users: [male_georgetown, female_umich])]
                
                beforeEach {
                    mockSpotFeedViewModelDelegate.resetAll()
                    mockUserRepository.resetAll()
                    female_umich.isVisible = true
                    male_georgetown.isVisible = true
                    mockUserRepository.localUsers = localUsers[0].users
                }
                
                it("should load local users") {
                    spotFeedViewModel.fetchLocalUsers()
                    
                    expect(mockSpotFeedViewModelDelegate.allLocalUsersCalledWith).toEventually(equal(localUsers))
                }
                
                it("should filter into sex categories") {
                    spotFeedViewModel.filtersActivated = true
                    let onlyFemaleUsers: [User] = [female_umich]
                    let onlyMaleUsers: [User] = [male_georgetown]
                    let expectedSexCategories = [UserCategory(title: "Men", users: onlyMaleUsers), UserCategory(title: "Women", users: onlyFemaleUsers)]
                    
                    spotFeedViewModel.fetchLocalUsers()
                    
                    expect(mockSpotFeedViewModelDelegate.sexFilteredUsersCalledWith).toEventually(equal(expectedSexCategories))
                }
                
                it("should filter into school categories") {
                    spotFeedViewModel.filtersActivated = true
                    let onlyUMichStudents: [User] = [female_umich]
                    let onlyGeorgetownUsers: [User] = [male_georgetown]
                    
                    let expectedSchoolCategories = [
                        UserCategory(title: male_georgetown.education[0].school, users: onlyGeorgetownUsers),
                        UserCategory(title: female_umich.education[0].school, users: onlyUMichStudents)]
                    
                    spotFeedViewModel.fetchLocalUsers()
                    
                    expect(mockSpotFeedViewModelDelegate.schoolFilteredUsersCalledWith).toEventually(equal(expectedSchoolCategories))
                }
                
                it("should call no local users if there are no local users") {
                    mockUserRepository.localUsers = []
                    spotFeedViewModel.fetchLocalUsers()
                    expect(mockSpotFeedViewModelDelegate.allLocalUsersCalledWith).toEventually(equal([]))
                    expect(mockSpotFeedViewModelDelegate.noLocalUsersCalled).toEventually(beTrue())
                }
                
                it("should call noVisibleLocalUsers if local users exist, but they're all invisible") {
                    female_umich.isVisible = false
                    male_georgetown.isVisible = false
                    
                    spotFeedViewModel.fetchLocalUsers()
                    
                    expect(mockSpotFeedViewModelDelegate.noVisibleLocalUsersCalled).toEventually(beTrue())
                }
                
                it("should call visibleLocalUsers if visible local users exist") {
                    female_umich.isVisible = false
                    male_georgetown.isVisible = true
                    
                    spotFeedViewModel.fetchLocalUsers()
                    
                    let visibleLocalUsersCategory = [UserCategory(title: "All Visible Local Users", users: [male_georgetown])]
                    
                    expect(mockSpotFeedViewModelDelegate.visibleLocalUsersCalledWith).toEventually(equal(visibleLocalUsersCategory))
                }
                
                xit("should call no filtered users if no users remain after filtering") {
                    spotFeedViewModel.fetchLocalUsers()
                    
                    expect(mockSpotFeedViewModelDelegate.allLocalUsersCalledWith).toEventually(equal(localUsers))
                    expect(mockSpotFeedViewModelDelegate.noFilteredUsersCalled).toEventually(beTrue())
                }
                
                it("should call delegate with a failedToFetchLocalUsers if fetching fails") {
                    mockUserRepository.shouldFailWithError = .failedToFetchLocalUsers("Failed")
                    spotFeedViewModel.fetchLocalUsers()
                    switch mockSpotFeedViewModelDelegate.errorCalledWith {
                        case .failedToFetchLocalUsers: _ = succeed()
                        default: fail()
                    }
                }
            }
        }
    }
}
