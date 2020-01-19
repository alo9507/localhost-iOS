//
//  NiblessViewController.swift
//  Contact
//
//  Created by Andrew O'Brien on 8/11/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import UIKit

open class NiblessView: UIView {
    
    // MARK: - Methods
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @available(*, unavailable,
    message: "Loading this view from a nib is unsupported in favor of initializer dependency injection."
    )
    public required init?(coder aDecoder: NSCoder) {
        fatalError("Loading this view from a nib is unsupported in favor of initializer dependency injection.")
    }
}

open class NiblessTableViewCell: UITableViewCell {
    
    @available(*, unavailable,
    message: "Loading this view from a nib is unsupported in favor of initializer dependency injection."
    )
    public required init?(coder aDecoder: NSCoder) {
        fatalError("Loading this view from a nib is unsupported in favor of initializer dependency injection.")
    }
}



