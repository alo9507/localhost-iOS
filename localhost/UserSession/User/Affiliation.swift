//
//  Affiliation.swift
//  Contact
//
//  Created by Andrew O'Brien on 12/13/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

struct Affiliation: Codable, Equatable {
    var organizationName: String
    var role: String
    
    var startDate: String
    var endDate: String
    
    var documentData: [String: String] {
        return ["organizationName": self.organizationName,
                "role": self.role,
                "startDate": self.startDate,
                "endDate": self.endDate
        ]
    }
    
    init(organizationName: String, role: String, startDate: String, endDate: String) {
        self.organizationName = organizationName
        self.role = role
        self.startDate = startDate
        self.endDate = endDate
    }
    
    init?(_ dictionary: [String: String]?) {
        self.organizationName = dictionary["organizationName"] as? String ?? ""
        self.role = dictionary["role"] as? String ?? ""
        self.startDate = dictionary["startDate"] as? String ?? ""
        self.endDate = dictionary["endDate"] as? String ?? ""
    }
}

