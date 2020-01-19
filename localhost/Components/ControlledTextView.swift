//
//  ControlledTextView.swift
//  Contact
//
//  Created by Andrew O'Brien on 11/10/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation
import UIKit

class ControlledTextView: UITextView {

    convenience init() {
        self.init(frame: CGRect.zero, textContainer: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChangeNotification), name: UITextView.textDidChangeNotification , object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func textDidChangeNotification(_ notif: Notification) {
        guard self == notif.object as? UITextView else {
            return
        }
        textDidChange()
    }

    func textDidChange() {
        // the text in the textview just changed, below goes the code for whatever you need to do given this event

        // or you can just set the textDidChangeHandler closure to execute every time the text changes, useful if you want to keep logic out of the class
        textDidChangeHandler?()
    }

    var textDidChangeHandler: (()->Void)?

}
