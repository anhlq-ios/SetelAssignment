//
//  LocationManager.swift
//  SetelAssignment
//
//  Created by Anh Le on 16/02/2022.
//

import Foundation
import CoreLocation

protocol LocationServiceType {
    func grantLocationPermissionIfNeeded() -> Bool
}

final class LocationService: NSObject, LocationServiceType {
    
    static let shared = LocationService(locationManager: CLLocationManager())
    
    private let locationManager: CLLocationManager
    private var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    private init(locationManager: CLLocationManager) {
        self.locationManager = locationManager
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        super.init()
        
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
}

// MARK: - LocationServiceType
extension LocationService {
    
    /// grant user's permission to get their location
    /// - Returns: return `true` if authorizationStatus is `notDeteremined`
    func grantLocationPermissionIfNeeded() -> Bool {
        if authorizationStatus == .notDetermined {
            locationManager.requestAlwaysAuthorization()
            return true
        } else {
            return false
        }
    }
}

extension LocationService: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location with error: \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locations.forEach { location in
            print("New location arrived: \(location)")
        }
    }
}
