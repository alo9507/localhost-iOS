//
//  InteractionState.swift
//  Contact
//
//  Created by Andrew O'Brien on 12/24/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation

struct InteractionState: OptionSet {
    let rawValue: Int
    
      // VALID STATES
//    (touched: false, focused: false, set: false, valid: true): 8
//    (touched: true, focused: true, set: false, valid: true): 11
//    (touched: true, focused: false, set: true, valid: true): 13
//    (touched: true, focused: true, set: true, valid: true): 15

      // INVALID STATES
//    (touched: true, focused: true, set: true, valid: false): 7
//    (touched: true, focused: false, set: true, valid: false): 5
    
    static let touched = InteractionState(rawValue: 1 << 0) // adds 1 to the InteractionState
    static let focused = InteractionState(rawValue: 1 << 1) // adds 2 to the InteractionState
    static let set = InteractionState(rawValue: 1 << 2) // adds 4 to the InteractionState
    static let valid = InteractionState(rawValue: 1 << 3) // adds 8 to the InteractionState
}
