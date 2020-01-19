//
//  MockLocationManager.swift
//  Contact
//
//  Created by Andrew O'Brien on 1/12/20.
//  Copyright © 2020 Andrew O'Brien. All rights reserved.
//

import Foundation
import CoreLocation

class MockLocationManager : CLLocationManager {
    var mockLocation: CLLocation?
    
    override var location: CLLocation? {
        return mockLocation
    }
    
    override init() {
        super.init()
    }
}
