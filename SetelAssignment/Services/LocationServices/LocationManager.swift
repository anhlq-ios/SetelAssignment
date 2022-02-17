//
//  LocationManager.swift
//  SetelAssignment
//
//  Created by Anh Le on 16/02/2022.
//

import Foundation
import CoreLocation
import RxSwift
import RxCocoa

protocol LocationServiceType {
    var currentLocation: BehaviorSubject<CLLocation?> { get }
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
    }
    
    let currentLocation: BehaviorSubject<CLLocation?> = BehaviorSubject<CLLocation?>(value: nil)
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
        switch manager.authorizationStatus {
            case .authorizedAlways, .authorizedWhenInUse:
                locationManager.startUpdatingLocation()
            default:
                break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location with error: \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }
        print("New location at long:\(newLocation.coordinate.longitude), lat:\(newLocation.coordinate.latitude)")
        if let lastLocation = try? currentLocation.value() {
            if lastLocation.coordinate != newLocation.coordinate {
                currentLocation.onNext(newLocation)
            }
        } else {
            currentLocation.onNext(newLocation)
        }
    }
}
