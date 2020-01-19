//
//  ReportingReason.swift
//  Contact
//
//  Created by Andrew O'Brien on 11/17/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import UIKit

let kUserReportingDidUpdateNotificationName = NSNotification.Name(rawValue: "kUserReportingDidUpdateNotificationName")

enum ReportingReason: String {
    case sensitiveImages
    case spam
    case abusive
    case harmful

    var rawValue: String {
        switch self {
        case .sensitiveImages: return "sensitiveImages"
        case .spam: return "spam"
        case .abusive: return "abusive"
        case .harmful: return "harmful"
        }
    }
}
