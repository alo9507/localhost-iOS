//
//  CheckMarkImageView.swift
//  Contact
//
//  Created by Andrew O'Brien on 12/13/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import UIKit

class CheckMarkImageView: UIImageView {
    private let inset: CGFloat = 1
    
    public var adjustedContentSize: CGSize {
        return CGSize(width: intrinsicContentSize.width + inset, height: intrinsicContentSize.height + inset)
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 15, height: 15)
    }
    
    override var alignmentRectInsets: UIEdgeInsets {
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
}
