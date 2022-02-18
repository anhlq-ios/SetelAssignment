//
//  LocationListViewController.swift
//  SetelAssignment
//
//  Created by Anh Le on 16/02/2022.
//  Copyright (c) 2022 All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LocationListViewController: UIViewController, StoryboardInstantiable {
    
    var viewModel: LocationListViewModel!
    
    class func create(with viewModel: LocationListViewModel) -> LocationListViewController {
        let vc = LocationListViewController.instantiateViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    private let disposeBag = DisposeBag()
    
    @IBOutlet private weak var longTextField: UITextField!
    @IBOutlet private weak var latTextField: UITextField!
    @IBOutlet private weak var addLocationButton: UIButton!
    @IBOutlet private weak var tableView: UITableView!
    
    @IBAction private func addLocationTapped(_ sender: Any) {
        view.endEditing(true)
        if let long = Double(longTextField.text ?? ""),
           let lat = Double(latTextField.text ?? "") {
            viewModel.addLocation(long: long, lat: lat)
        } else {
            showAlert(title: nil, message: "Incorrect data")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }
    
    func bind(to viewModel: LocationListViewModel) {
        viewModel.errorMessage.subscribe(onNext: { [weak self] message in
            self?.showAlert(title: nil, message: message)
        }).disposed(by: disposeBag)
        
        viewModel.locations.distinctUntilChanged()
            .subscribe(onNext: { [weak self] _ in
                self?.tableView.reloadData()
            }).disposed(by: disposeBag)
    }
    
    private func configureUI() {
        tableView.register(LocationTableViewCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        let header = UILabel(frame: CGRect(origin: .zero, size: CGSize(width: view.bounds.width, height: 40)))
        header.text = "Available location points"
        tableView.tableHeaderView = header
        longTextField.keyboardType = .numbersAndPunctuation
        latTextField.keyboardType = .numbersAndPunctuation
    }
    
    private func showAlert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            alert.dismiss(animated: true) { [weak self] in
                self?.longTextField.text = ""
                self?.latTextField.text = ""
            }
        }))
        present(alert, animated: true, completion: nil)
    }
}

extension LocationListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.locations.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeReusableCell(LocationTableViewCell.self, for: indexPath)
        let location = viewModel.locations.value[indexPath.row]
        let viewModel = LocationCellViewModel(location: location)
        cell.viewModel = viewModel
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
            case .delete:
                viewModel.deleteLocation(at: indexPath.row)
            default:
                return
        }
    }
}
