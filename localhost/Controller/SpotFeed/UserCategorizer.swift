//
//  UserCategorizer.swift
//  Contact
//
//  Created by Andrew O'Brien on 1/12/20.
//  Copyright © 2020 Andrew O'Brien. All rights reserved.
//

import Foundation

class UserCategorizer {
    static func categorize(_ users: [User], _ filterCategory: FilterCategory) -> [UserCategory] {
        switch filterCategory {
        case .sex:
            var men = [User]()
            var women = [User]()
            
            for user in users {
                if user.sex == .male {
                    men.append(user)
                }
                if user.sex == .female {
                    women.append(user)
                }
            }
            
            var userCategories = [UserCategory]()
            let womenCategory = UserCategory(title: "Women", users: women)
            let menCategory = UserCategory(title: "Men", users: men)
            userCategories.append(menCategory)
            userCategories.append(womenCategory)
            return userCategories
            
        case .school:
            var schools = [UserCategory]()
            
            for user in users {
                for education in user.education {
                    let schoolAlreadyInList = schools.contains(where: { (userCategory) -> Bool in
                        return userCategory.title == education.school
                    })
                    
                    let userNotAlreadyInList = !schools.contains(where: { (userCategory) -> Bool in
                        return userCategory.users.contains(where: { (schoolUser) -> Bool in
                            return schoolUser.uid == user.uid
                        })
                    })
                    
                    if  schoolAlreadyInList && userNotAlreadyInList {
                        let index = schools.firstIndex { (userCategory) -> Bool in
                            return userCategory.title == education.school
                        }
                        schools[index!].users.append(user)
                    } else {
                        schools.append(UserCategory(title: education.school, users: [user]))
                    }
                }
            }
            
            return schools
        default:
            return []
        }
    }
}
