//
//  MainViewModel.swift
//  SetelAssignment
//
//  Created by Anh Le on 16/02/2022.
//  Copyright (c) 2022 All rights reserved.
//

import Foundation

protocol MainViewModelInput {
    func viewDidLoad()
}

protocol MainViewModelOutput {
    
}

protocol MainViewModel: MainViewModelInput, MainViewModelOutput { }

class DefaultMainViewModel: MainViewModel {
    
    // MARK: - OUTPUT
    
    // MARK: - Private properties
    private let locationService: LocationServiceType
    
    init(locationService: LocationServiceType) {
        self.locationService = locationService
    }
}

// MARK: - INPUT. View event methods
extension DefaultMainViewModel {
    func viewDidLoad() {
        _ = locationService.grantLocationPermissionIfNeeded()
    }
}
