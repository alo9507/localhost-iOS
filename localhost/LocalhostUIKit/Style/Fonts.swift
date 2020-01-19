//
//  Fonts.swift
//  Contact
//
//  Created by Andrew O'Brien on 12/13/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

class Fonts {
    public static func avenirNext_regular(_ size: CGFloat) -> UIFont {
        guard let font = UIFont(name: "AvenirNext-Regular", size: size) else {
            preconditionFailure("Unable to find Font")
        }
        return font
    }
    
    public static func avenirNext_Ultralight(_ size: CGFloat) -> UIFont {
        guard let font = UIFont(name: "AvenirNext-UltraLight", size: size) else {
            preconditionFailure("Unable to find Font")
        }
        return font
    }
    
    public static func avenirNext_UltraLightItalic(_ size: CGFloat) -> UIFont {
        guard let font = UIFont(name: "AvenirNext-UltraLightItalic", size: size) else {
            preconditionFailure("Unable to find Font")
        }
        return font
    }
    
    public static func avenirNext_bold(_ size: CGFloat) -> UIFont {
        guard let font = UIFont(name: "AvenirNext-Bold", size: size) else {
            preconditionFailure("Unable to find Font")
        }
        return font
    }
    
    public static func avenirNext_demibold(_ size: CGFloat) -> UIFont {
        guard let font = UIFont(name: "AvenirNext-DemiBold", size: size) else {
            preconditionFailure("Unable to find Font")
        }
        return font
    }
    
    public static func avenirNext_boldItalic(_ size: CGFloat) -> UIFont {
        guard let font = UIFont(name: "AvenirNext-BoldItalic", size: size) else {
            preconditionFailure("Unable to find Font")
        }
        return font
    }
}

extension UIFont {
    func swiftUI() -> Font {
        return .custom(self.fontName, size: self.pointSize)
    }
}
