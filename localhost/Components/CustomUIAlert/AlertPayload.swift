//
//  AlertMessage.swift
//  Contact
//
//  Created by Andrew O'Brien on 11/19/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation
import UIKit

struct AlertPayload {
    var title: String
    var titleColor: UIColor
    var message: String
    var messageColor: UIColor
    var buttons: [AlertButton]
    var backgroundColor: UIColor
}
