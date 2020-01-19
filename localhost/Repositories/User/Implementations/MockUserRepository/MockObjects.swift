//
//  MockObjects.swift
//  Contact
//
//  Created by Andrew O'Brien on 1/12/20.
//  Copyright © 2020 Andrew O'Brien. All rights reserved.
//

import Foundation

class MockObjects {
    public static func mockLocalUsers() -> [User] {
        return [user1(), user2()]
    }
    
    static func user1() -> User {
        let user1 = User(jsonDict: [:])
        user1.uid = "user1ID"
        user1.firstName = "Lindsey"
        user1.lastName = "Smith"
        user1.sex = .female
        user1.age = 25
        user1.profileImageUrl = "https://images.unsplash.com/photo-1479936343636-73cdc5aae0c3?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1400&q=80"
        let affiliation1 = Affiliation(organizationName: "Company 1", role: "Product Manager and Software Engineer", startDate: "09-08-2010", endDate: "09-082015")
        user1.affiliations.append(affiliation1)
        
        let education1 = Education(school: "University College", degree: .phd, major: "Lingusitics", minor: "Film and Media Studies", graduationYear: "2023")
        user1.education.append(education1)
        user1.topics = ["Topic 1", "Topic 2", "Topic 3"]
        user1.skills = ["Skills 1", "Skills 2", "Skills 3"]
        return user1
    }
    
    static func user2() -> User {
        let user2 = User(jsonDict: [:])
        user2.uid = "user2ID"
        user2.firstName = "Jonathan"
        user2.lastName = "Reynolds"
        user2.age = 30
        user2.sex = .male
        user2.profileImageUrl = "https://images.unsplash.com/photo-1485528562718-2ae1c8419ae2?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1381&q=80"
        let user2_affiliation1 = Affiliation(organizationName: "Company 1", role: "Product Manager and Software Engineer", startDate: "09-08-2010", endDate: "09-082015")
        user2.affiliations.append(user2_affiliation1)
        
        let user2_education1 = Education(school: "Really Really Long School Name", degree: .phd, major: "Lingusitics", minor: "Film and Media Studies", graduationYear: "2023")
        user2.education.append(user2_education1)
        
        user2.topics = ["Topic 1", "Topic 2", "Topic 3"]
        user2.skills = ["Skills 1", "Skills 2", "Skills 3"]
        return user2
    }
}
