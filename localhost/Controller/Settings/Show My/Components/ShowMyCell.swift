//
//  ShowMyCell.swift
//  Contact
//
//  Created by Andrew O'Brien on 1/1/20.
//  Copyright © 2020 Andrew O'Brien. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class ShowMyCell: UITableViewCell {
    var showMyOption: UILabel = {
        let showMyOption = UILabel()
        showMyOption.textAlignment = .center
        showMyOption.font = Fonts.avenirNext_bold(24)
        return showMyOption
    }()
    
    private var strikeThrough = UIView()
    
    var showThisOption: Bool = false {
        didSet {
            if showThisOption {
                styleSelected()
            } else {
                styleUnselected()
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        layer.cornerRadius = 25
        layer.masksToBounds = true
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        selectionStyle = .none
        render()
    }
    
    func render() {
        addSubview(showMyOption)
        
        showMyOption.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.equalToSuperview()
            make.height.equalTo(50)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func styleSelected() {
        showMyOption.textColor = UIColor.lhTurquoise
        
        for view in showMyOption.subviews {
            view.removeFromSuperview()
        }
    }
    
    private func styleUnselected() {
        showMyOption.textColor = UIColor.lhInvalidTextField
        
        showMyOption.addSubview(strikeThrough)
        
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
