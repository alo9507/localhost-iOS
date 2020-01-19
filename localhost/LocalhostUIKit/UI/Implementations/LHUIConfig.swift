//
//  LHUIConfig.swift
//  Contact
//
//  Created by Andrew O'Brien on 11/17/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import UIKit

class LHUIConfiguration: UIGenericConfigurationProtocol {
    let colorGray0: UIColor = UIColor.darkModeColor(hexString: "#000000")
    let colorGray3: UIColor = UIColor.darkModeColor(hexString: "#333333")
    let colorGray9: UIColor = UIColor.darkModeColor(hexString: "#f4f4f4")

    let mainThemeBackgroundColor: UIColor = UIColor.lhPurple
    let mainThemeForegroundColor: UIColor = UIColor.lhTurquoise
    let mainTextColor: UIColor = UIColor.white
    let mainSubtextColor: UIColor = UIColor(hexString: "#7c7c7c").darkModed
    let statusBarStyle: UIStatusBarStyle = .default
    let hairlineColor: UIColor = UIColor(hexString: "#d6d6d6").darkModed

    let regularSmallFont = Fonts.avenirNext_regular(14)
    let regularMediumFont = Fonts.avenirNext_bold(14)
    let regularLargeFont = Fonts.avenirNext_bold(18)
    let mediumBoldFont = Fonts.avenirNext_bold(16)
    let boldLargeFont = Fonts.avenirNext_bold(24)
    let boldSmallFont = Fonts.avenirNext_bold(12)
    let boldSuperSmallFont = Fonts.avenirNext_bold(10)
    let boldSuperLargeFont = Fonts.avenirNext_bold(30)
    let italicMediumFont = Fonts.avenirNext_boldItalic(14)

    let homeImage = UIImage.localImage("home-icon", template: true)

    func regularFont(size: CGFloat) -> UIFont {
        return Fonts.avenirNext_regular(size)
    }
    func boldFont(size: CGFloat) -> UIFont {
        return Fonts.avenirNext_bold(size)
    }

    func configureUI() {
        UITabBar.appearance().barTintColor = UIColor.init(hexString: "#31CAFF", withAlpha: 0.75)
        UITabBar.appearance().tintColor = UIColor.init(hexString: "#31CAFF", withAlpha: 0.75)
        UITabBar.appearance().unselectedItemTintColor = self.mainTextColor
        UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor : self.mainTextColor,
                                                          .font: self.boldSuperSmallFont],
                                                         for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor : self.mainThemeForegroundColor,
                                                          .font: self.boldSuperSmallFont],
                                                         for: .selected)

        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().shadowImage = UIImage()

        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().isTranslucent = true
        UINavigationBar.appearance().barTintColor = UIColor(hexString: "#f6f7fa").darkModed
        UINavigationBar.appearance().tintColor = self.mainThemeForegroundColor
    }
}
