//
//  Location.swift
//  SetelAssignment
//
//  Created by Anh Le on 17/02/2022.
//

import Foundation
import CoreLocation

class Location: NSObject, NSCoding, NSSecureCoding {
    func encode(with coder: NSCoder) {
        coder.encode(long, forKey: "long")
        coder.encode(lat, forKey: "lat")
        
    }
    
    required init?(coder: NSCoder) {
        long = coder.decodeDouble(forKey: "long")
        lat = coder.decodeDouble(forKey: "lat")
    }
    static var supportsSecureCoding: Bool = true
    
    let long: Double
    let lat: Double
    
    init(long: Double, lat: Double) {
        self.long = long
        self.lat = lat
    }
    
    func mapToCLLocation() -> CLLocation {
        return CLLocation(latitude: lat, longitude: long)
    }
}
