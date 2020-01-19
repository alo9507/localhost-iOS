//
//  PasswordVerificationLabel.swift
//  Contact
//
//  Created by Andrew O'Brien on 12/13/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation
import UIKit

class PasswordVerificationLabel: OnboardingLabel {
    var imageView = CheckMarkImageView(image: UIImage(named: "mock"))
    
    var isValid: Bool = false {
        didSet {
            updateLabel(for: isValid)
        }
    }
    
    private let leftPadding: CGFloat = 7
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        let width = size.width + imageView.adjustedContentSize.width + leftPadding
        return CGSize(width: width, height: size.height)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setProperties()
        setImageView()
    }
    
    convenience init(title: String) {
        self.init(frame: .zero)
        self.text = title
        layoutIfNeeded()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.layer.cornerRadius = imageView.frame.height / 2
    }
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 0, left: imageView.frame.width + leftPadding, bottom: 0, right: 0)
        super.drawText(in: rect.inset(by: insets))
    }
    
    private func setProperties() {
        translatesAutoresizingMaskIntoConstraints = false
        numberOfLines = 1
        lineBreakMode = .byWordWrapping
        textColor = UIColor(red: 0.51, green: 0.54, blue: 0.65, alpha: 1)
        imageView.backgroundColor = UIColor(red: 0.51, green: 0.54, blue: 0.65, alpha: 1)
    }
    
    override func setTextProperties(text: String) {
        let textString = NSMutableAttributedString(
            string: text, attributes: [.font: Fonts.avenirNext_regular(14)])
        
        let textRange = NSRange(location: 0, length: textString.length)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.33
        textString.addAttribute(.paragraphStyle, value: paragraphStyle, range: textRange)
        textString.addAttribute(.kern, value: 0.07, range: textRange)
        attributedText = textString
    }
    
    private func setImageView() {
        addSubview(imageView)
        
        imageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
        }
        
        imageView.contentMode = .center
    }
    
    private func updateLabel(for state: Bool) {
        let color = state ? UIColor(red: 0.3, green: 0.85, blue: 0.39, alpha: 1) : UIColor(red: 0.51, green: 0.54, blue: 0.65, alpha: 1)
        
        UIView.animate(withDuration: 0.2) {
            self.imageView.backgroundColor = color
        }
        
        UIView.transition(with: self, duration: 0.2, options: .transitionCrossDissolve, animations: {
            self.textColor = color
        })
    }
}
