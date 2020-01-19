//
//  OnboardingTextField.swift
//  Contact
//
//  Created by Andrew O'Brien on 12/12/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import UIKit
import SnapKit

class OnboardingTextField: UITextField {
    var currentState: FieldState = FieldState.fresh
    
    func render() { apply(self.currentState) }
    func apply(_ state: FieldState) {
        switch state.interactionState {
        // VALID STATES
            
        // (touched: false, focused: false, set: false, valid: true): 8
        case 8:
            UIView.animate(withDuration: 0.2) {
                self.backgroundColor = UIColor.lhValidTextField
            }
            
        // (touched: true, focused: false, set: false, valid: true): 9
        case 9:
            UIView.animate(withDuration: 0.2) {
                self.backgroundColor = UIColor.lhValidTextField
            }
            
        // (touched: true, focused: true, set: false, valid: true): 11
        case 11:
            UIView.animate(withDuration: 0.2) {
                self.backgroundColor = UIColor.lhValidFocusedTextField
            }
            
        // (touched: true, focused: false, set: true, valid: true): 13
        case 13:
            UIView.animate(withDuration: 0.2) {
                //                    self.backgroundColor = UIColor.lhValidTextField
                self.backgroundColor = UIColor.lhValidSetTextField
            }
            
        // (touched: true, focused: true, set: true, valid: true): 15
        case 15:
            UIView.animate(withDuration: 0.2) {
                self.backgroundColor = UIColor.lhValidFocusedTextField
            }
            
        // INVALID STATES
            
        // (touched: true, focused: false, set: true, valid: false): 5
        case 5:
            UIView.animate(withDuration: 0.2) {
                self.borderColor = UIColor(red: 1, green: 0.07, blue: 0.07, alpha: 1)
                self.backgroundColor = UIColor(red: 1, green: 0.55, blue: 0.55, alpha: 0.6)
            }
            
        // (touched: true, focused: true, set: true, valid: false): 7
        case 7:
            UIView.animate(withDuration: 0.2) {
                self.borderColor = UIColor(red: 1, green: 0.07, blue: 0.07, alpha: 1)
                self.backgroundColor = UIColor(red: 1, green: 0.55, blue: 0.55, alpha: 0.6)
            }
        
        // (touched: true, focused: true, set: false, valid: false): 3
        case 3:
            UIView.animate(withDuration: 0.2) {
                self.borderColor = UIColor(red: 1, green: 0.07, blue: 0.07, alpha: 1)
                self.backgroundColor = UIColor(red: 1, green: 0.55, blue: 0.55, alpha: 0.6)
            }
            
        default:
            fatalError("No FieldState matching \(state.interactionState). Since this is even you likely forgot to set touched to true!")
        }
    }
    
    private let verticalPadding: CGFloat = 6.5
    
    private var padding: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    }
    
    public var borderColor: UIColor = UIColor(red: 0.16, green: 0.31, blue: 0.72, alpha: 1) {
        didSet {
            bottomBorder.layer.borderColor = borderColor.cgColor
        }
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    var isValid: Bool = true {
        didSet {
            self.currentState.valid = isValid
            self.render()
        }
    }
    
    private var bottomBorder = UIView()
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: CGFloat.greatestFiniteMagnitude, height: 50)
    }
    
    init(placeholder: String? = nil, keyboardType: UIKeyboardType = .default, returnKeyType: UIReturnKeyType = .default) {
        super.init(frame: .zero)
        setProperties(placeholder: placeholder, keyboardType: keyboardType, returnKeyType: returnKeyType)
        //        setupBottomBorder()
        
        addTarget(self, action: #selector(textFieldEditingDidBegin(_:)), for: .editingDidBegin)
        addTarget(self, action: #selector(textFieldEditingDidEnd(_:)), for: .editingDidEnd)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //    override func caretRect(for position: UITextPosition) -> CGRect {
    //        var rect = super.caretRect(for: position)
    //        let size = CGSize(width: 1, height: 24)
    //
    //        let y = rect.origin.y - (size.height - rect.size.height) / 2
    //        rect = CGRect(origin: CGPoint(x: rect.origin.x, y: y), size: size)
    //        return rect
    //    }
    
    private func setProperties(placeholder: String?, keyboardType: UIKeyboardType, returnKeyType: UIReturnKeyType) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.keyboardType = keyboardType
        self.returnKeyType = returnKeyType
        textAlignment = .left
        contentMode = .center
        tintColor = UIColor.lhTurquoise
        font = Fonts.avenirNext_demibold(20)
        textColor = UIColor.lhTurquoise
        layer.borderWidth = 2
        layer.borderColor = UIColor.lhYellow.cgColor
        backgroundColor = UIColor(red: 0.5, green: 0.58, blue: 0.78, alpha: 0)
        layer.cornerRadius = 10
        frame.size.height = 150
        if let placeholder = placeholder {
            attributedPlaceholder = NSAttributedString(string: placeholder,
                                                       attributes: [
                                                        .foregroundColor: UIColor.lhTurquoise,
                                                        .font: Fonts.avenirNext_UltraLightItalic(20)
            ])
        }
    }
}

extension OnboardingTextField {
    private func setupBottomBorder() {
        addSubview(bottomBorder)
        
        bottomBorder.snp.makeConstraints { (make) in
            make.height.equalTo(2)
            make.width.bottom.equalToSuperview()
        }
        
        bottomBorder.alpha = 0.50
        bottomBorder.layer.borderWidth = 2
        bottomBorder.layer.borderColor = borderColor.cgColor
    }
}

extension OnboardingTextField {
    @objc
    func textFieldEditingDidBegin(_ textField: UITextField) {
        textField.selectAll(nil)
        self.currentState.touched = true
        self.currentState.focused = true
        self.currentState.valid = isValid
        self.render()
    }
    
    @objc
    func textFieldEditingDidEnd(_ textField: UITextField) {
        self.currentState.focused = false
        self.currentState.valid = isValid
        self.render()
    }
}
