//
//  DismissableViewController.swift
//  Contact
//
//  Created by Andrew O'Brien on 1/4/20.
//  Copyright © 2020 Andrew O'Brien. All rights reserved.
//

import Foundation
import UIKit

class DismissableViewController: NiblessViewController {
    lazy var downwardArrow: UIImageView = {
        let downwardArrow = UIImageView(image: UIImage(named:"downward-arrow"))
        downwardArrow.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeUnintriguedVC))
        downwardArrow.addGestureRecognizer(tapGesture)
        return downwardArrow
    }()
    
    override func viewDidLoad() {
        view.addSubview(downwardArrow)
        
        downwardArrow.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(30)
        }
    }
    
    @objc
    func closeUnintriguedVC() {
        self.dismiss(animated: true, completion: nil)
    }
}
