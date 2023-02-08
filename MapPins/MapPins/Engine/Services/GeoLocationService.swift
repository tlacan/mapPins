//
//  GeoLocationService.swift
//  MapPins
//
//  Created by thomas lacan on 02/02/2023.
//

import Foundation
import CoreLocation
import Combine

class GeoLocationService: NSObject, ObservableObject {
    let locationManager: CLLocationManager
    @Published var latestUserLocation: CLLocation?
    @Published var continuous: Bool = false

    override init() {
        locationManager = CLLocationManager()
        super.init()
        locationManager.delegate = self
    }

    var hasGeolocationAccess: Bool {
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways: return true
        default: return false
        }
    }

    var hasAskedForGeolocation: Bool {
        switch locationManager.authorizationStatus {
        case .notDetermined: return false
        default: return true
        }
    }

    var deniedGeolocationAccess: Bool {
        switch locationManager.authorizationStatus {
        case .denied, .restricted: return true
        default: return false
        }
    }

    func startUpdateLocationIfNeeded(continuous: Bool) {
        self.continuous = continuous
        if hasGeolocationAccess {
            locationManager.startUpdatingLocation()
        } else if !hasAskedForGeolocation {
            locationManager.requestWhenInUseAuthorization()
        }
    }

    func stopUpdateLocation() {
        locationManager.stopUpdatingLocation()
    }
}

extension GeoLocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            if !continuous {
                stopUpdateLocation()
            }
            latestUserLocation = location
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        startUpdateLocationIfNeeded(continuous: continuous)
    }
}
