//
//  ProfileDetailGroupStackView.swift
//  Contact
//
//  Created by Andrew O'Brien on 1/10/20.
//  Copyright © 2020 Andrew O'Brien. All rights reserved.
//

import Foundation
import UIKit

class ProfileDetailGroupStackView: UIStackView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setProperties()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setProperties() {
        translatesAutoresizingMaskIntoConstraints = false
        axis = .vertical
        distribution = .fill
        alignment = .leading
        spacing = 10
        
        isLayoutMarginsRelativeArrangement = true
        directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        
        addBackground(borderColor: UIColor.darkLhPurple, borderWidth: 2, cornerRadius: 15, shadowColor: .gray, shadowOpacity: 0.5, shadowRadius: 15, shadowOffset: CGSize(width: 10, height: 10))
    }
}

class ProfileDetailGroupLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        text = ""
        setProperties()
    }
    
    convenience init(_ text: String) {
        self.init(frame: .zero)
        self.text = text
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setProperties() {
        textAlignment = .left
        numberOfLines = 0
        sizeToFit()
        textColor = UIColor.lhPink
        font = Fonts.avenirNext_bold(24)
    }
}
