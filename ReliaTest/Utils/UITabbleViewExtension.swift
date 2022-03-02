//
//  UITabbleViewExtension.swift
//  ReliaTest
//
//  Created by Ty Pham on 02/03/2022.
//

import UIKit

extension UITableView {
    func registerCellFromNib<T>(_ cell: T.Type) where T: UITableViewCell {
        let name = cell.className
        let nib = UINib(nibName: name, bundle: nil)
        register(nib, forCellReuseIdentifier: name)
    }
    
    func dequeueCell<T>(_ cell: T.Type, forIndexPath indexPath: IndexPath) -> T where T: UITableViewCell {
        return dequeueReusableCell(withIdentifier: cell.className, for: indexPath) as! T
    }
}
