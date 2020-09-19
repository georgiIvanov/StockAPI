//
//  UIViewController+Extensions.swift
//  StockAPI
//
//  Created by Voro on 19.09.20.
//

import UIKit

public extension UIViewController {
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
}
