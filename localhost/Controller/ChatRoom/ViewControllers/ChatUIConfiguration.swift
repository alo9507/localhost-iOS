//
//  ChatUIConfiguration.swift
//  Contact
//
//  Created by Andrew O'Brien on 1/19/20.
//  Copyright © 2020 Andrew O'Brien. All rights reserved.
//

import Foundation
import UIKit

class ChatUIConfiguration: ChatUIConfigurationProtocol {
    let primaryColor: UIColor
    let backgroundColor: UIColor
    let inputTextViewBgColor: UIColor = {
        if #available(iOS 13.0, *) {
            return UIColor { (traitCollection: UITraitCollection) -> UIColor in
                switch traitCollection.userInterfaceStyle {
                    case
                    .unspecified,
                    .light: return .white
                    case .dark: return .white
                    @unknown default:
                        return .white
                }
            }
        } else {
            return .white
        }
    }()

    let inputTextViewTextColor: UIColor
    let inputPlaceholderTextColor: UIColor = {
        if #available(iOS 13.0, *) {
            return UIColor { (traitCollection: UITraitCollection) -> UIColor in
                switch traitCollection.userInterfaceStyle {
                    case
                    .unspecified,
                    .light: return UIColor(hexString: "#979797")
                    case .dark: return UIColor(hexString: "#686868")
                    @unknown default:
                        return .white
                }
            }
        } else {
            return UIColor(hexString: "#979797")
        }
    }()

    required init(uiConfig: UIGenericConfigurationProtocol) {
        backgroundColor = uiConfig.mainThemeBackgroundColor
        inputTextViewTextColor = uiConfig.colorGray0
        primaryColor = uiConfig.mainThemeForegroundColor
    }
}
