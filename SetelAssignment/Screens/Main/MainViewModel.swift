//
//  MainViewModel.swift
//  SetelAssignment
//
//  Created by Anh Le on 16/02/2022.
//  Copyright (c) 2022 All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import CoreLocation

protocol MainCoordinatorType {
    func routeToLocationList()
    func routeToWifiList()
}

protocol MainViewModelInput {
    func viewDidLoad()
    func viewWillAppear()
    func showLocationList()
    func showWifiList()
    func updateRadius(_ radius: Double)
}

protocol MainViewModelOutput {
    var isConnected: BehaviorRelay<Bool> { get }
    var radius: BehaviorRelay<Double> { get }
}

protocol MainViewModel: MainViewModelInput, MainViewModelOutput { }

class DefaultMainViewModel: MainViewModel {
    
    // MARK: - OUTPUT
    let isConnected = BehaviorRelay<Bool>(value: false)
    let radius = BehaviorRelay<Double>(value: 0)
    
    // MARK: - Private properties
    private let coordinator: MainCoordinatorType
    private let locationService: LocationServiceType
    private let userDefaultPersistent: UserDefaultPersistentType
    
    private let disposeBag = DisposeBag()
    
    init(coordinator: MainCoordinatorType,
         locationService: LocationServiceType,
         userDefaultPersistent: UserDefaultPersistentType) {
        self.coordinator = coordinator
        self.locationService = locationService
        self.userDefaultPersistent = userDefaultPersistent
        
        configureViewModel()
    }
    
    private func configureViewModel() {
        Observable.combineLatest(locationService.currentLocation.compactMap({ $0 }).asObservable(),
                                 radius.asObservable())
            .subscribe(onNext: { [weak self] (location, radius) in
                self?.checkConnectedUser(at: location, radius: radius)
            }).disposed(by: disposeBag)
        
        radius.accept(userDefaultPersistent.getRadius())
    }
    
    private func checkConnectedUser(at location: CLLocation, radius: Double) {
        let saveLocations = userDefaultPersistent.getLocations()
        var isConnected = false
        saveLocations.forEach { saveLocation in
            let distance = saveLocation.distance(from: location)
            print("Distance from current location: \(distance)")
            if distance <= radius {
                isConnected = true
                return
            }
        }
        self.isConnected.accept(isConnected)
    }
}

// MARK: - INPUT. View event methods
extension DefaultMainViewModel {
    func viewDidLoad() {
        _ = locationService.grantLocationPermissionIfNeeded()
    }
    
    func viewWillAppear() {
        radius.accept(radius.value)
    }
    
    func showLocationList() {
        coordinator.routeToLocationList()
    }
    
    func showWifiList() {
        coordinator.routeToWifiList()
    }
    
    func updateRadius(_ radius: Double) {
        userDefaultPersistent.saveRadius(radius)
        self.radius.accept(radius)
    }
}
