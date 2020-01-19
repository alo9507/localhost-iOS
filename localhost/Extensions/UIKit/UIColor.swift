//
//  UIColor.swift
//  Contact
//
//  Created by Andrew O'Brien on 7/14/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation
import UIKit
import ChameleonFramework

extension UIColor {
    static var myAppPink: UIColor {
        return UIColor.init(hexString: "#BF17C5", withAlpha: 1.0)
    }
}


extension UIColor {
    
    static var lhPurple = UIColor(hexString: "#4450C7", alpha: 1.0)
    static var darkLhPurple =  UIColor(hexString: "#333B96", alpha: 1.0)
    
    static var lhYellow = UIColor(hexString: "#FEE552", alpha: 1.0)
    
    static var lhTurquoise = UIColor(hexString: "#2CD3CB", alpha: 1.0)
    
    static var lhPink = UIColor(hexString: "#FD78AD", alpha: 1.0)
    
    static var lhValidTextField = UIColor(red: 0.5, green: 0.58, blue: 0.78, alpha: 0.1)
    static var lhValidFocusedTextField = UIColor(red: 0.5, green: 0.58, blue: 0.78, alpha: 0.3)
    static var lhInvalidTextField = UIColor(red: 1, green: 0.55, blue: 0.55, alpha: 0.6)
    static var lhValidSetTextField = UIColor(red: 1, green: 0.8, blue: 0.55, alpha: 0.3)
    
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)

        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }

        var color: UInt32 = 0
        scanner.scanHexInt32(&color)

        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask

        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0

        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }

    static func darkModeColor(hexString: String) -> UIColor {
        let lightColor = UIColor(hexString: hexString)
        return {
            if #available(iOS 13.0, *) {
                return UIColor { (traitCollection: UITraitCollection) -> UIColor in
                    switch traitCollection.userInterfaceStyle {
                        case
                        .unspecified,
                        .light: return lightColor
                        case .dark: return lightColor.inverted
                        @unknown default:
                            return lightColor
                    }
                }
            } else {
                return lightColor
            }
            }()
    }

    static func modedColor(light: String, dark: String) -> UIColor {
        let lightColor = UIColor(hexString: light)
        let darkColor = UIColor(hexString: dark)
        return {
            if #available(iOS 13.0, *) {
                return UIColor { (traitCollection: UITraitCollection) -> UIColor in
                    switch traitCollection.userInterfaceStyle {
                        case
                        .unspecified,
                        .light: return lightColor
                        case .dark: return darkColor
                        @unknown default:
                            return lightColor
                    }
                }
            } else {
                return lightColor
            }
            }()
    }

    var inverted: UIColor {
        var r: CGFloat = 0.0, g: CGFloat = 0.0, b: CGFloat = 0.0, a: CGFloat = 0.0
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        return UIColor(red: (1 - r), green: (1 - g), blue: (1 - b), alpha: a)
    }

    var darkModed: UIColor {
        return {
            if #available(iOS 13.0, *) {
                return UIColor { (traitCollection: UITraitCollection) -> UIColor in
                    switch traitCollection.userInterfaceStyle {
                        case
                        .unspecified,
                        .light: return self
                        case .dark: return self.inverted
                        @unknown default:
                            return self
                    }
                }
            } else {
                return self
            }
            }()
    }

    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0

        getRed(&r, green: &g, blue: &b, alpha: &a)

        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0

        return String(format:"#%06x", rgb)
    }
}
