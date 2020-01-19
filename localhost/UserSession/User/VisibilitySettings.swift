//
//  VisibilitySettings.swift
//  Contact
//
//  Created by Andrew O'Brien on 11/16/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation

enum VisibilityFilters {
    case isVisible
    case isNotCurrentUser
    case isSex
    case isNotBlockedByOtherUser
    case otherUserIsNotBlockedByCurrentUser
    case isInAgeRange
    case isOfSexualOrientation
    case isInLocation
    case currentUserPassesOtherUsersCriteria
}

struct VisibilitySettings: Codable, Equatable {
    var sex: Sex
    var sexualOrientation: SexualOrientation
    var lowerAgeBound: Int
    var upperAgeBound: Int
    var testSetting: TestLocation
    var blockedUsers: [String]
    var blockedBy: [String]
    
    init() {
        self.sex = .all
        self.sexualOrientation = .all
        self.lowerAgeBound = 0
        self.upperAgeBound = 100
        self.testSetting = .techEvent
        self.blockedUsers = []
        self.blockedBy = []
    }
    
    init(sex: Sex,
         sexualOrientation: SexualOrientation,
         lowerAgeBound: Int,
         upperAgeBound: Int,
         testSetting: TestLocation,
         blockedUsers: [String],
         blockedBy: [String]
        ) {
            self.sex = sex
            self.sexualOrientation = sexualOrientation
            self.lowerAgeBound = lowerAgeBound
            self.upperAgeBound = upperAgeBound
            self.testSetting = testSetting
            self.blockedBy = blockedBy
            self.blockedUsers = blockedUsers
    }
    
    init(dictionary: [String:Any]) {
        lowerAgeBound = dictionary["lowerAgeBound"] as? Int ?? 0
        upperAgeBound = dictionary["upperAgeBound"] as? Int ?? 0
        sex = Sex(rawValue: dictionary["sex"] as! String) ?? .all
        testSetting = TestLocation(rawValue: dictionary["testSetting"] as? String ?? "techEvent") ?? .techEvent
        sexualOrientation = SexualOrientation(rawValue: dictionary["sexualOrientation"] as? String ?? "all") ?? .all
        blockedBy = dictionary["blockedBy"] as? [String] ?? []
        blockedUsers = dictionary["blockedUsers"] as? [String] ?? []
    }
    
    static func == (lhs: VisibilitySettings, rhs: VisibilitySettings) -> Bool {
        return
                lhs.sex == rhs.sex &&
                lhs.sexualOrientation.rawValue == rhs.sexualOrientation.rawValue &&
                lhs.lowerAgeBound == rhs.lowerAgeBound &&
                lhs.upperAgeBound == rhs.upperAgeBound &&
                lhs.testSetting.rawValue == rhs.testSetting.rawValue
    }
    
    var documentData: [String: Any] {
        return ["sex": self.sex.rawValue,
                "sexualOrientation": self.sexualOrientation.rawValue,
                "lowerAgeBound": self.lowerAgeBound,
                "upperAgeBound": self.upperAgeBound,
                "testSetting": self.testSetting.rawValue,
                "blockedBy": self.blockedBy,
                "blockedUsers": self.blockedBy,
        ]
    }
    
    func filter(
        _ testingUser: User,
        _ testedUser: User,
        filters: [VisibilityFilters],
        reciprocalCheck: Bool = true
        ) -> Bool {
        
        var filters = filters
        
        if !reciprocalCheck && filters.contains(.currentUserPassesOtherUsersCriteria) {
            if let indexOfReciprocalCheck = filters.firstIndex(of: .currentUserPassesOtherUsersCriteria) {
                filters.remove(at: indexOfReciprocalCheck)
            }
        }
        
        var filterResult = true
        for filter in filters {
            switch filter {
            case .isVisible:
                if !testedUser.isVisible { filterResult = false; break }
            case .isNotCurrentUser:
                if testedUser.uid == testingUser.uid { filterResult = false; break }
            case .isInLocation:
                if TestLocation(rawValue: testedUser.testLocation) != self.testSetting { filterResult = false; break }
            case .isInAgeRange:
                if testedUser.age < lowerAgeBound || testedUser.age > upperAgeBound { filterResult = false; break }
            case .isSex:
                if sex == .all { continue; }
                if  testedUser.sex != self.sex  { filterResult = false; break }
            case .otherUserIsNotBlockedByCurrentUser:
                if self.blockedUsers.contains(testedUser.uid) && testedUser.visibilitySettings.blockedBy.contains(testingUser.uid) { filterResult = false; break }
            case .isNotBlockedByOtherUser:
                if self.blockedBy.contains(testedUser.uid) && testedUser.visibilitySettings.blockedUsers.contains(testingUser.uid) { filterResult = false; break }
            case .isOfSexualOrientation:
                if sexualOrientation == .all { continue; }
                if testedUser.sexualOrientation != self.sexualOrientation  { filterResult = false; break }
            case .currentUserPassesOtherUsersCriteria:
                if !(testedUser.visibilitySettings.filter(testedUser, testingUser, filters: filters, reciprocalCheck: false)) { filterResult = false; break }
            }
            if filterResult == false { break }
        }
        
        return filterResult
    }
}
