//
//  LocationAccessViewModel.swift
//  Contact
//
//  Created by Andrew O'Brien on 12/27/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationAccessViewModelDelegate: class {
    func locationDetected(_ location: String)
}

class LocationAccessViewModel: NSObject {
    var locationManager: CLLocationManager
    
    weak var delegate: LocationAccessViewModelDelegate?
    
    init(locationManager: CLLocationManager) {
        self.locationManager = locationManager
        super.init()
    }
}

// MARK: Location Manager
extension LocationAccessViewModel: CLLocationManagerDelegate {
    @objc
    func requestLocationAccess() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            
            locationManager.stopUpdatingLocation()
            
            print("LOCATION: longitude = \(location.coordinate.longitude), latitude = \(location.coordinate.latitude)")
            
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            
            CLGeocoder().reverseGeocodeLocation(location) { (placemark, error) in
                var cityState: String
                let locality = placemark?.first?.locality
                let administrativeArea = placemark?.first?.administrativeArea
                self.delegate?.locationDetected("\(locality!), \(administrativeArea!)")
            }
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("LOCATION ERROR: \(error)")
    }
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .notDetermined:
            print("AUTH STATUS: .notDetermined")
            locationManager.requestAlwaysAuthorization()
            break
        case .authorizedWhenInUse:
            print("AUTH STATUS: .authorizedWhenInUse")
            locationManager.startUpdatingLocation()
            break
        case .authorizedAlways:
            print("AUTH STATUS: .authorizedAlways")
            locationManager.startUpdatingLocation()
            break
        case .restricted:
            print("AUTH STATUS: .restricted")
            break
        case .denied:
            print("AUTH STATUS: .denied")
            break
        default:
            break
        }
    }
}

