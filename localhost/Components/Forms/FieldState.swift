//
//  FieldState.swift
//  Contact
//
//  Created by Andrew O'Brien on 12/24/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation

class FieldState {
    static let fresh: FieldState = FieldState(touched: false, focused: false, set: false, valid: true)
    
    var touched: Bool
    var focused: Bool
    var set: Bool
    var valid: Bool
    
    init(touched: Bool, focused: Bool, set: Bool, valid: Bool) {
        self.touched = touched
        self.focused = focused
        self.set = set
        self.valid = valid
    }
    
    var interactionState: Int {
        var state: InteractionState = []
        if touched { state = state.union(.touched) }
        if focused { state = state.union(.focused) }
        if set { state = state.union(.set) }
        if valid { state = state.union(.valid) }
        
        return state.rawValue
    }
}
