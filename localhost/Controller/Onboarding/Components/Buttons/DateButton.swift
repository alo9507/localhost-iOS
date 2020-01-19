//
//  DateButton.swift
//  Contact
//
//  Created by Andrew O'Brien on 12/23/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation
import UIKit

class DateButtonState: FieldState {
    static let freshDate: DateButtonState = DateButtonState(date: "3/2018", touched: false, focused: false, set: false, valid: true)
    
    public var date: String?
    
    public init(date: String, touched: Bool, focused: Bool, set: Bool, valid: Bool) {
        self.date = date
        super.init(touched: touched, focused: focused, set: set, valid: valid)
    }
}

public class DateButton: UIButton {
    var currentState: DateButtonState = DateButtonState.freshDate
    
    func render() { apply(self.currentState) }
    
          // VALID STATES
    //    (touched: false, focused: false, set: false, valid: true): 8
    //    (touched: true, focused: true, set: false, valid: true): 11
    //    (touched: true, focused: false, set: true, valid: true): 13
    //    (touched: true, focused: true, set: true, valid: true): 15

          // ERROR STATES
    //    (touched: true, focused: false, set: true, valid: false): 5
    //    (touched: true, focused: true, set: true, valid: false): 7
    func apply(_ state: DateButtonState) {
        let attributedTitle = NSAttributedString(string: state.date!, attributes: [
            NSAttributedString.Key.foregroundColor : UIColor.lhTurquoise,
            NSAttributedString.Key.font: Fonts.avenirNext_demibold(24)
        ])
        
        self.setAttributedTitle(attributedTitle, for: .normal)
        
        switch state.interactionState {
            // VALID STATES
            
            // (touched: false, focused: false, set: false, valid: true): 8
            case 8:
                let attributedTitle = NSAttributedString(string: state.date!, attributes: [
                    NSAttributedString.Key.foregroundColor : UIColor.lhPink,
                    NSAttributedString.Key.font: Fonts.avenirNext_demibold(24)
                ])
                
                self.setAttributedTitle(attributedTitle, for: .normal)
                
                layer.borderColor = UIColor.gray.cgColor
                layer.backgroundColor = UIColor.lhPurple.cgColor
            
            // (touched: true, focused: false, set: false, valid: true): 9
            case 9:
                let attributedTitle = NSAttributedString(string: state.date!, attributes: [
                    NSAttributedString.Key.foregroundColor : UIColor.lhPink,
                    NSAttributedString.Key.font: Fonts.avenirNext_demibold(24)
                ])
                
                self.setAttributedTitle(attributedTitle, for: .normal)
                
                layer.borderColor = UIColor.gray.cgColor
                layer.backgroundColor = UIColor.lhPurple.cgColor
            
            // (touched: true, focused: true, set: false, valid: true): 11
            case 11:
                layer.borderColor = UIColor.lhPink.cgColor
                layer.backgroundColor = UIColor.lhPurple.cgColor
            
            // ILLEGAL - untouched but set?
            case 12:
            // (touched: false, focused: false, set: true, valid: true): 12
            let attributedTitle = NSAttributedString(string: state.date!, attributes: [
                NSAttributedString.Key.foregroundColor : UIColor.lhPink,
                NSAttributedString.Key.font: Fonts.avenirNext_demibold(24)
            ])
            
            self.setAttributedTitle(attributedTitle, for: .normal)
            
            layer.borderColor = UIColor.gray.cgColor
            layer.backgroundColor = UIColor.lhPurple.cgColor
            
            // (touched: true, focused: false, set: true, valid: true): 13
            case 13:
                layer.borderColor = UIColor.lhYellow.cgColor
                layer.backgroundColor = UIColor.darkLhPurple.cgColor
            
            // (touched: true, focused: true, set: true, valid: true): 15
            case 15:
                layer.borderColor = UIColor.lhYellow.cgColor
                layer.backgroundColor = UIColor.lhPurple.cgColor
            
            // ERROR STATES
            // (touched: true, focused: false, set: true, valid: false): 5
            case 5:
                layer.borderColor = UIColor.gray.cgColor
                layer.backgroundColor = UIColor.red.cgColor
            
            // (touched: true, focused: true, set: true, valid: false): 7
            case 7:
                layer.borderColor = UIColor.lhPink.cgColor
                layer.backgroundColor = UIColor.red.cgColor
            
            default:
                fatalError("No FieldState matching \(state.interactionState)")
        }
    }
    
    private var title: String
    
    override init(frame: CGRect) {
        self.title = "Set a title"
        super.init(frame: frame)
    }
    
    convenience init(_ text: String) {
        self.init(frame: .zero)
        self.title = text
        setProperties()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setProperties() {
        let attributedTitle = NSAttributedString(string: title, attributes: [
            NSAttributedString.Key.foregroundColor : UIColor.lhPink,
            NSAttributedString.Key.font: Fonts.avenirNext_demibold(24)
        ])
        
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 2
        layer.cornerRadius = 20
        sizeToFit()
        
        setAttributedTitle(attributedTitle, for: .normal)
    }
}
