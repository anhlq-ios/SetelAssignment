//
//  UserDefaultStorage.swift
//  SetelAssignment
//
//  Created by Anh Le on 16/02/2022.
//

import Foundation
import CoreLocation

protocol RadiusPersistent {
    func getRadius() -> Double
    func saveRadius(_ radius: Double)
}

protocol LocationsPersistent {
    func addLocation(_ location: CLLocation)
    func removeLocation(_ location: CLLocation)
    func getLocations() -> [CLLocation]
}

protocol WifiPersistent {
    func addWifi(_ name: String)
    func removeWifi(_ name: String)
    func getWifis() -> [String]
}

protocol UserDefaultPersistentType: RadiusPersistent, LocationsPersistent, WifiPersistent {
    
}

final class UserDefaultPersistent: UserDefaultPersistentType {
    
    static let shared = UserDefaultPersistent()
    
    private let persistent = UserDefaults.standard
    
    private init() {}
    
    // MARK: - RadiusPersistent
    func getRadius() -> Double {
        return persistent.double(forKey: Constants.UserDefaultKeys.radius)
    }
    
    func saveRadius(_ radius: Double) {
        persistent.set(radius, forKey: Constants.UserDefaultKeys.radius)
    }
    
    // MARK: - LocationsPersistent
    func addLocation(_ location: CLLocation) {
        var locations = getLocations()
        locations.append(location)
        let mapLocations = locations.map { Location(long: $0.coordinate.longitude, lat: $0.coordinate.latitude) }
        saveData(mapLocations as Any, forKey: Constants.UserDefaultKeys.locations)
    }
    
    func removeLocation(_ location: CLLocation) {
        var locations = getLocations()
        locations.removeAll(where: { $0.coordinate == location.coordinate })
        let mapLocations = locations.map { Location(long: $0.coordinate.longitude, lat: $0.coordinate.latitude) }
        saveData(mapLocations as Any, forKey: Constants.UserDefaultKeys.locations)
    }
    
    func getLocations() -> [CLLocation] {
        let locations = getDatas(Location.self, forKey: Constants.UserDefaultKeys.locations)
        return locations.map { $0.mapToCLLocation() }
    }
    
    // MARK: - WifiPersistent
    func addWifi(_ name: String) {
        var wifis = getWifis()
        wifis.append(name)
        persistent.set(wifis, forKey: Constants.UserDefaultKeys.wifi)
    }
    
    func removeWifi(_ name: String) {
        var wifis = getWifis()
        wifis.removeAll(where: { $0 == name })
        persistent.set(wifis, forKey: Constants.UserDefaultKeys.wifi)
    }
    
    func getWifis() -> [String] {
        return persistent.stringArray(forKey: Constants.UserDefaultKeys.locations) ?? []
    }
}

extension UserDefaultPersistent {
    private func saveData(_ data: Any, forKey key: String) {
        guard let data = try? NSKeyedArchiver.archivedData(withRootObject: data, requiringSecureCoding: true) else {
            fatalError("Unable to archived data: \(data) for key \(key)")
        }
        persistent.set(data, forKey: key)
    }
    
    private func getDatas<T: NSObject>(_ type: T.Type, forKey key: String) -> [T] where T: NSSecureCoding {
        guard let data = persistent.data(forKey: key),
              let result = try? NSKeyedUnarchiver.unarchivedArrayOfObjects(ofClass: T.self, from: data) else {
            print("Unable to unarchived datas for key: \(key)")
            return []
        }
        return result
    }
}
