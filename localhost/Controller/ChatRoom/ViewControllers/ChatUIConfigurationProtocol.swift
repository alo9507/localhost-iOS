//
//  ChatUIConfigurationProtocol.swift
//  Contact
//
//  Created by Andrew O'Brien on 1/19/20.
//  Copyright © 2020 Andrew O'Brien. All rights reserved.
//

import Foundation
import UIKit

protocol ChatUIConfigurationProtocol {
    var primaryColor: UIColor {get}
    var backgroundColor: UIColor {get}
    var inputTextViewBgColor: UIColor {get}
    var inputTextViewTextColor: UIColor {get}
    var inputPlaceholderTextColor: UIColor {get}
    init(uiConfig: UIGenericConfigurationProtocol)
}
