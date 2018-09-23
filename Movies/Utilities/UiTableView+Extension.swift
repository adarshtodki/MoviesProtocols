//
//  UiTableView+Extension.swift
//  Movies
//
//  Created by Adarsh Todki on 22/09/18.
//  Copyright © 2018 Sakhatech. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    func registerCellNib<T: UITableViewCell>(type: T.Type) {
        register(UINib(nibName: type.className, bundle: nil),
                 forCellReuseIdentifier: type.className)
    }
    
    func dequeCell<T: UITableViewCell>(type: T.Type, indexPath: IndexPath) -> T {
        if let cell = self.dequeueReusableCell(withIdentifier: type.className) as? T {
            return cell
        }
        fatalError("Cell is not registered")
    }
}

extension NSObject {
    class var className: String {
        return String(describing: self)
    }
}


