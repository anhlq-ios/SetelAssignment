//
//  MainViewController.swift
//  SetelAssignment
//
//  Created by Anh Le on 16/02/2022.
//  Copyright (c) 2022 All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MainViewController: UIViewController, StoryboardInstantiable {
    
    var viewModel: MainViewModel!
    
    class func create(with viewModel: MainViewModel) -> MainViewController {
        let vc = MainViewController.instantiateViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    @IBOutlet private weak var connectedStatusLabel: UILabel!
    @IBOutlet private weak var showLocationListButton: UIButton!
    @IBOutlet private weak var radiusTextField: UITextField!
    
    @IBAction private func showLocationListAction(_ sender: Any) {
        viewModel.showLocationList()
    }
    
    @IBAction private func showWifiListAction(_ sender: Any) {
        viewModel.showWifiList()
    }
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }
    
    private func configureUI() {
        title = "MainViewController"
        radiusTextField.keyboardType = .decimalPad
        radiusTextField.inputAccessoryView = makeToolBar()
    }
    
    private func bind(to viewModel: MainViewModel) {
        viewModel.isConnected
            .subscribe(onNext: { [weak self] isConnected in
                self?.updateUI(isConnected: isConnected)
            }).disposed(by: disposeBag)
        
        viewModel.radius.map { "\($0)" }.bind(to: radiusTextField.rx.text).disposed(by: disposeBag)
        
        radiusTextField.rx.controlEvent(.editingDidEnd).subscribe(onNext: { [weak self] in
            guard let newRadius = Double(self?.radiusTextField.text ?? "") else { return }
            self?.viewModel.updateRadius(newRadius)
        }).disposed(by: disposeBag)
    }
    
    private func updateUI(isConnected: Bool) {
        let text = isConnected ? "Connected" : "Disconnected"
        let textColor = isConnected ? UIColor.green : UIColor.red
        connectedStatusLabel.text = text
        connectedStatusLabel.textColor = textColor
    }
    
    private func makeToolBar() -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
        toolBar.setItems([doneButton], animated: true)
        return toolBar
    }
    
    @objc private func doneButtonTapped() {
        view.endEditing(true)
    }
}
