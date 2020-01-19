//
//  LHGenericBaseModel.swift
//  Contact
//
//  Created by Andrew O'Brien on 11/17/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation

protocol GenericJSONParsable {
    init(jsonDict: [String: Any])
}

protocol GenericBaseModel: GenericJSONParsable, CustomStringConvertible {}
