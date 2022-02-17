//
//  LocationTableViewCell.swift
//  SetelAssignment
//
//  Created by Anh Le on 17/02/2022.
//

import UIKit
import CoreLocation

struct LocationCellViewModel {
    let longText: String
    let latText: String
    
    init(location: CLLocation) {
        longText = "Long: \(location.coordinate.longitude.formatted())"
        latText = "Lat: \(location.coordinate.latitude.formatted())"
    }
}
class LocationTableViewCell: UITableViewCell, CellReusable {
    
    @IBOutlet private weak var longLabel: UILabel!
    @IBOutlet private weak var latLabel: UILabel!
    
    var viewModel: LocationCellViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            conigureUI(with: viewModel)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    private func conigureUI(with viewModel: LocationCellViewModel) {
        longLabel.text = viewModel.longText
        latLabel.text = viewModel.latText
    }
}
