//
//  ViewControllerAssembly.swift
//  StockAPI
//
//  Created by Voro on 19.09.20.
//

import Foundation
import Swinject
import SwinjectStoryboard

class ViewControllerAssembly: Assembly {

    func assemble(container: Container) {
        container.storyboardInitCompleted(TimeSeriesStockViewController.self) { (res, controller) in
            
        }
    }
}
