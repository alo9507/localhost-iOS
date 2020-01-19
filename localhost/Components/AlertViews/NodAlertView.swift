//
//  NodAlertView.swift
//  Contact
//
//  Created by Andrew O'Brien on 12/25/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

protocol NodAlertViewDelegate: class {
    func addButtonTapped(message: String)
    func cancelButtonTapped()
}

class NodAlertView: UIViewController {
    var alertTitle: UILabel = {
        let alertTitle = UILabel()
        alertTitle.text = "TITLE"
        return alertTitle
    }()
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Nod Options"
        return titleLabel
    }()
    
    lazy var messageLabel: UILabel = {
        let messageLabel = UILabel()
        messageLabel.text = "Add a message to your nod?"
        return messageLabel
    }()
    
    lazy var alertTextField: UITextField = {
        let alertTextField = UITextField()
        return alertTextField
    }()
    
    lazy var cancelButton: UIButton = {
        let cancelButton = UIButton()
        return cancelButton
    }()
    
    lazy var okButton: UIButton = {
        let okButton = UIButton()
        return okButton
    }()
    
    
    var delegate: NodAlertViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertTextField.becomeFirstResponder()
        
        providesPresentationContextTransitionStyle = true
        definesPresentationContext = true
        modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        
        render()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
        
        self.view.alpha = 0;
        self.view.frame.origin.y = self.view.frame.origin.y + 50
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.view.alpha = 1.0;
            self.view.frame.origin.y = self.view.frame.origin.y - 50
        })
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layoutIfNeeded()
//        cancelButton.addBorder(side: .Top, color: UIColor.gray, width: 1)
//        cancelButton.addBorder(side: .Right, color: UIColor.gray, width: 1)
//        okButton.addBorder(side: .Top, color: UIColor.gray, width: 1)
    }
}

extension NodAlertView {
    func setupView() {
        self.view.layer.cornerRadius = 15
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    }
    
    @objc
    func onTapCancelButton(_ sender: Any) {
        alertTextField.resignFirstResponder()
        delegate?.cancelButtonTapped()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc
    func onTapOkButton(_ sender: Any) {
        alertTextField.resignFirstResponder()
        delegate?.addButtonTapped(message: alertTextField.text!)
        self.dismiss(animated: true, completion: nil)
    }
}

extension NodAlertView {
    func render() {
        constructHierarchy()
        activateConstraints()
    }
    
    func constructHierarchy() {
        view.addSubview(alertTitle)
    }
    
    func activateConstraints() {
        alertTitle.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
}
