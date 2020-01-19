//
//  MyOrganizationsStackView.swift
//  Contact
//
//  Created by Andrew O'Brien on 12/14/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import UIKit

class MyOrganizationsStackView: UIStackView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setProperties()
    }
    
    func setProperties() {
        translatesAutoresizingMaskIntoConstraints = false
        axis = .vertical
        distribution = .equalSpacing
        alignment = .center
        spacing = 10
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
