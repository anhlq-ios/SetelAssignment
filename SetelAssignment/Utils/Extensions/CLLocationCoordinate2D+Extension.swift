//
//  CLLocationCoordinate2D+Extension.swift
//  SetelAssignment
//
//  Created by Anh Le on 16/02/2022.
//

import CoreLocation

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
