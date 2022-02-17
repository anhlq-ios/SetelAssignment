//
//  LocationListViewModel.swift
//  SetelAssignment
//
//  Created by Anh Le on 16/02/2022.
//  Copyright (c) 2022 All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import CoreLocation

protocol LocationListViewModelInput {
    func viewDidLoad()
    func addLocation(long: Double, lat: Double)
    func deleteLocation(at index: Int)
}

protocol LocationListViewModelOutput {
    var locations: BehaviorRelay<[CLLocation]> { get }
    var errorMessage: PublishRelay<String> { get }
}

protocol LocationListViewModel: LocationListViewModelInput, LocationListViewModelOutput { }

class DefaultLocationListViewModel: LocationListViewModel {
    
    // MARK: - OUTPUT
    let locations = BehaviorRelay<[CLLocation]>(value: [])
    let errorMessage = PublishRelay<String>()
    // Private properties
    private let locationsPersistent: LocationsPersistent
    
    init(locationsPersistent: LocationsPersistent) {
        self.locationsPersistent = locationsPersistent
    }
    
    private func validateInfo(long: Double, lat: Double) -> Bool {
        let range = Constants.Coordinate.min...Constants.Coordinate.max
        return range.contains(long) && range.contains(lat)
    }
    
    private func reloadLocations() {
        locations.accept(locationsPersistent.getLocations())
    }
}

// MARK: - INPUT. View event methods
extension DefaultLocationListViewModel {
    func viewDidLoad() {
        reloadLocations()
    }
    
    func addLocation(long: Double, lat: Double) {
        if !validateInfo(long: long, lat: lat) {
            let message = "Incorrect data. long and lat must be from \(Constants.Coordinate.min) to \(Constants.Coordinate.max)"
            errorMessage.accept(message)
            return
        }

        let isDuplicate = locations.value.contains(where: {
            $0.coordinate.latitude == lat && $0.coordinate.longitude == long })
        if isDuplicate {
            let message = "Duplicate point long: \(long), lat: \(lat)"
            errorMessage.accept(message)
            return
        }
        
        let location = CLLocation(latitude: lat, longitude: long)
        locationsPersistent.addLocation(location)
        reloadLocations()
    }
    
    func deleteLocation(at index: Int) {
        let location = locations.value[index]
        locationsPersistent.removeLocation(location)
        reloadLocations()
    }
}
