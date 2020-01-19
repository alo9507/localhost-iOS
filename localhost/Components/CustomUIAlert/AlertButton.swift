//
//  AlertButton.swift
//  Contact
//
//  Created by Andrew O'Brien on 11/19/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation
import UIKit

struct AlertButton {
    var title: String
    var action: (() -> Void)
    var titleColor: UIColor
    var backgroundColor: UIColor
}
