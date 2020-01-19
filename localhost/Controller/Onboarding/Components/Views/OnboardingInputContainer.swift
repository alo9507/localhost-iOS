//
//  OnboardingInputContainer.swift
//  Contact
//
//  Created by Andrew O'Brien on 12/13/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class OnboardingInputContainer: UIView {
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 315, height: 700)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = 18
        layer.backgroundColor = UIColor.clear.cgColor
        
        applyShadow(color: UIColor(red: 0.26, green: 0.31, blue: 0.77, alpha: 0.2).cgColor, opacity: 1, radius: 4, offset: .zero)
    }
}

extension OnboardingInputContainer {
    func resizeToFitSubviews(_ addHeight: CGFloat = 75) {
        var w: CGFloat = 0.0
        var h: CGFloat = 0.0

        subviews.forEach { (v) in
            let fw = v.frame.origin.x + v.frame.size.width
            let fh = v.frame.origin.y + v.frame.size.height
            w = max(fw, w)
            h = max(fh, h)
        }
        
        frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: w, height: h)
        
        self.snp.makeConstraints { (make) in
            make.height.equalTo(frame.height + addHeight)
        }
        
        layoutSubviews()
    }
}
