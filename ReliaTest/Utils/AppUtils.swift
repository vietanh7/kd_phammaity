//
//  AppUtils.swift
//  ReliaTest
//
//  Created by Ty Pham on 02/03/2022.
//

import UIKit

extension UIViewController {
    class var storyboardId: String {
        return "\(self)"
    }
}

extension String {
    func capitalizeFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
}

enum AppStoryboards: String {
    case main
    case setup

    var name: String {
        return rawValue.capitalizeFirstLetter()
    }

    var instance: UIStoryboard {
        return UIStoryboard(name: name, bundle: Bundle.main)
    }

    func instantiate<T: UIViewController>(viewControllerClass: T.Type) -> T {
        return instance.instantiateViewController(withIdentifier: viewControllerClass.storyboardId) as! T
    }

    func instantiateInitial<T: UIViewController>(viewControllerClass: T.Type) -> T? {
        return instance.instantiateInitialViewController() as? T
    }
    
    static func loadNibNamed<T: UIView>(ViewClass: T.Type) -> T {
        return Bundle.main.loadNibNamed(ViewClass.className, owner: self, options: nil)![0] as! T
    }
}
