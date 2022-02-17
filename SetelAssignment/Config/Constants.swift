//
//  Constants.swift
//  SetelAssignment
//
//  Created by Anh Le on 16/02/2022.
//

import Foundation

enum Constants {
    enum UserDefaultKeys {
        static let radius = "radius"
        static let locations = "locations"
        static let wifi = "wifi"
    }
    
    enum Coordinate {
        static let max: Double = 180
        static let min: Double = -180
    }
}
