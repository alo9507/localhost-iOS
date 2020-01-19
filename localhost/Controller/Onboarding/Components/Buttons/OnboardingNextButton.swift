//
//  NextButton.swift
//  Contact
//
//  Created by Andrew O'Brien on 12/12/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation
import UIKit

class OnboardingNextButton: UIButton {
    let inactiveGray = UIColor.gray
    
    var isActive: Bool = false {
        didSet {setButton(for: isActive)}
    }
    
    lazy var gradientLayer = CAGradientLayer()
        .gradientLayer(
            colors: [inactiveGray, inactiveGray],
            locations: [0,1],
            orientation: (startPoint: CGPoint(x: 0, y: 1), endPoint: CGPoint(x: 1, y: 1)),
            cornerRadius: intrinsicContentSize.height / 2
    )
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 50, height: 50)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setProperties()
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = intrinsicContentSize.height / 2
        
        CATransaction.begin()
        gradientLayer.frame = bounds
        CATransaction.commit()
    }
    
    func setProperties() {
        adjustsImageWhenHighlighted = false
        translatesAutoresizingMaskIntoConstraints = false
        setImage(UIImage(named: "next-button"), for: .normal)
        contentMode = .center
        imageView?.contentMode = .scaleAspectFit
        
        applyShadow(color: UIColor(red: 0, green: 0, blue: 0, alpha: 0.15).cgColor, opacity: 1, radius: 10, offset: CGSize(width: 0, height: 2))
    }
    
    func setButton(for state: Bool) {
        isEnabled = state
        gradientLayer.colors = state ? [UIColor.lhTurquoise.cgColor, UIColor.lhTurquoise.cgColor] : [inactiveGray.cgColor, inactiveGray.cgColor]
        layer.shadowOpacity = state ? 1 : 0
        
        UIView.animate(withDuration: 0.16, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 15, options: [.curveEaseInOut], animations: { [weak self] in
            self?.transform = state ? .identity : CGAffineTransform(scaleX: 0.92, y: 0.92)
        })
    }
}
