//
//  OnboardingProgressLabel.swift
//  Contact
//
//  Created by Andrew O'Brien on 12/13/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import UIKit

typealias ProgressCount = (index: Int, total: Int)

class OnboardingProgressLabel: UILabel {
    
    let progressCount: ProgressCount
    
    private let horizontalInset: CGFloat = 9
    private let verticalInset: CGFloat = 6
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + (horizontalInset * 2), height: size.height + (verticalInset * 2))
    }
    
    init(progressCount: ProgressCount) {
        self.progressCount = progressCount
        
        super.init(frame: .zero)
        
        setProperties()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: UIEdgeInsets(top: verticalInset, left: horizontalInset, bottom: verticalInset, right: horizontalInset)))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 5
    }
    
    func setProperties() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor(red: 0.94, green: 0.94, blue: 0.96, alpha: 1)
        lineBreakMode = .byWordWrapping
        numberOfLines = 0
        layer.masksToBounds = true
        textColor = UIColor(red: 0.51, green: 0.54, blue: 0.65, alpha: 1)
        
        let textString = NSMutableAttributedString(string: "\(progressCount.index) / \(progressCount.total)", attributes: [.font: Fonts.avenirNext_regular(11)])
        let textRange = NSRange(location: 0, length: textString.length)
        let paragraphStyle = NSMutableParagraphStyle()
        textString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: textRange)
        attributedText = textString
        sizeToFit()
    }
    
}
