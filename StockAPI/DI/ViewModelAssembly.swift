//
//  ViewModelAssembly.swift
//  StockAPI
//
//  Created by Voro on 19.09.20.
//

import Foundation
import Swinject

class ViewModelAssembly: Assembly {

    func assemble(container: Container) {
        container.register(StockQuotesViewModelProtocol.self) { (res) in
            return StockQuotesViewModel(stocksServiceApi: res.resolve(StocksApiServiceProtocol.self)!)
        }
    }
}
