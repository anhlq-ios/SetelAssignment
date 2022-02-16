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
        return DefaultMainViewModel(locationService: LocationService.shared)
    }
    
    private func makeMainScreen() -> MainViewController {
        let viewModel = makeMainViewModel()
        let view = MainViewController.create(with: viewModel)
        return view
    }
}
