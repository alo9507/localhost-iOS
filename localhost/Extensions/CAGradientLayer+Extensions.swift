//
//  CAGradientLayer+Extensions.swift
//  Contact
//
//  Created by Andrew O'Brien on 12/12/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation
import UIKit

public typealias GradientOrientation = (startPoint: CGPoint, endPoint: CGPoint)

extension CAGradientLayer {
    public func gradientLayer(colors: [UIColor], locations: [NSNumber]? = nil, orientation: GradientOrientation, cornerRadius: CGFloat = 0, name: String? = nil) -> CAGradientLayer {
        self.colors = colors
        self.locations = locations
        self.startPoint = orientation.startPoint
        self.endPoint = orientation.endPoint
        self.frame = bounds
        self.cornerRadius = cornerRadius
        self.name = name
        return self
    }
}
