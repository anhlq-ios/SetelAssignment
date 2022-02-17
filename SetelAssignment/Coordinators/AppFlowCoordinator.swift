//
//  AppFlowCoordinator.swift
//  ExampleMVVM
//
//  Created by Oleh Kudinov on 03.03.19.
//

import UIKit

final class AppFlowCoordinator {

    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewController = makeMainScreen()
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension AppFlowCoordinator {
    private func makeMainViewModel() -> MainViewModel {
        return DefaultMainViewModel(coordinator: self,
                                    locationService: LocationService.shared,
                                    userDefaultPersistent: UserDefaultPersistent.shared)
    }
    
    private func makeMainScreen() -> MainViewController {
        let viewModel = makeMainViewModel()
        let viewController = MainViewController.create(with: viewModel)
        return viewController
    }
    
    private func makeLocationListViewModel() -> LocationListViewModel {
        return DefaultLocationListViewModel(locationsPersistent: UserDefaultPersistent.shared)
    }
    
    private func makeLocationListScreen() -> LocationListViewController {
        let viewModel = makeLocationListViewModel()
        let viewController = LocationListViewController.create(with: viewModel)
        return viewController
    }
}

extension AppFlowCoordinator: MainCoordinatorType {
    func routeToWifiList() {
        
    }
    
    func routeToLocationList() {
        let viewController = makeLocationListScreen()
        navigationController.pushViewController(viewController, animated: true)
    }
}
