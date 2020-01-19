//
//  ShowMyOption.swift
//  Contact
//
//  Created by Andrew O'Brien on 1/1/20.
//  Copyright © 2020 Andrew O'Brien. All rights reserved.
//

import Foundation
import UIKit

class ShowMyOption: UILabel {
    private var strikeThrough = UIView()
    
    let selected: Bool
    
    init(_ text: String, selected: Bool) {
        self.selected = selected
        super.init(frame: .zero)
        self.text = text
        setupProperties()
        
        if selected {
            styleSelected()
        } else {
            styleUnselected()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ShowMyOption {
    private func setupProperties() {
        textAlignment = .center
        font = Fonts.avenirNext_bold(24)
    }
    
    private func styleSelected() {
        textColor = UIColor.lhTurquoise
    }
    
    private func styleUnselected() {
        textColor = UIColor.lhInvalidTextField
        
        addSubview(strikeThrough)
        
        strikeThrough.snp.makeConstraints { (make) in
            make.height.equalTo(2)
            make.center.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        strikeThrough.alpha = 0.5
        strikeThrough.layer.shadowColor = UIColor.gray.cgColor
        strikeThrough.layer.shadowOffset = CGSize(width: 2, height: 2)
        strikeThrough.layer.shadowRadius = 10
        strikeThrough.layer.borderWidth = 2
        strikeThrough.layer.borderColor = UIColor.red.cgColor
    }
}
