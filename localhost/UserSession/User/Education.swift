//
//  Education.swift
//  Contact
//
//  Created by Andrew O'Brien on 12/13/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

enum Degree: String, Codable {
    case bs = "B.S."
    case ba = "B.A."
    case phd = "Ph.D."
    case masters = "M.A."
    case bfa = "B.F.A."
    case mba = "M.B.A."
    case highschool = "High School"
}

struct Education: Codable, Equatable {
    var school: String
    var degree: Degree
    var major: String
    var minor: String
    var graduationYear: String
    
    var documentData: [String: String] {
        return ["school": self.school,
                "degree": self.degree.rawValue,
                "major": self.major,
                "minor": self.minor,
                "graduationYear": self.graduationYear
        ]
    }
    
    init(school: String, degree: Degree, major: String, minor: String, graduationYear: String) {
        self.school = school
        self.degree = degree
        self.major = major
        self.minor = minor
        self.graduationYear = graduationYear
    }
    
    init?(_ dictionary: [String: String]?) {
        self.school = dictionary["school"] as? String ?? ""
        self.degree = dictionary["degree"] as? Degree ?? .ba
        self.major = dictionary["major"] as? String ?? ""
        self.minor = dictionary["minor"] as? String ?? ""
        self.graduationYear = dictionary["graduationYear"] as? String ?? ""
    }
}
