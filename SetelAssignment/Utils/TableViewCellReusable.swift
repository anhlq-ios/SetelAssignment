//
//  TableViewCellReusable.swift
//  SetelAssignment
//
//  Created by Anh Le on 17/02/2022.
//

import UIKit

protocol CellReusable: AnyObject {
    
}

extension UITableView {
    func register<T: UITableViewCell>(_ type: T.Type) where T: CellReusable {
        self.register(UINib(nibName: String(describing: type.self), bundle: nil), forCellReuseIdentifier: String(describing: type.self))
    }
    
    func dequeReusableCell<T: UITableViewCell>(_ type: T.Type, for indexPath: IndexPath) -> T where T: CellReusable {
        guard let cell = self.dequeueReusableCell(withIdentifier: String(describing: type.self), for: indexPath) as? T else {
            fatalError()
        }
        return cell
    }
}
