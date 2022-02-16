//
//  MainViewController.swift
//  SetelAssignment
//
//  Created by Anh Le on 16/02/2022.
//  Copyright (c) 2022 All rights reserved.
//

import UIKit

class MainViewController: UIViewController, StoryboardInstantiable {
    
    var viewModel: MainViewModel!
    
    class func create(with viewModel: MainViewModel) -> MainViewController {
        let vc = MainViewController.instantiateViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bind(to: viewModel)
        viewModel.viewDidLoad()
    }
    
    private func bind(to viewModel: MainViewModel) {
        title = "MainViewController"
    }
}
