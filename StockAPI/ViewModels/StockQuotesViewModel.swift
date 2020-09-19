//
//  StockQuotesViewModel.swift
//  StockAPI
//
//  Created by Voro on 19.09.20.
//

import Foundation

protocol StockQuotesViewModelProtocol: class {
    
}

class StockQuotesViewModel {
    let stocksServiceApi: StocksApiServiceProtocol
    
    init(stocksServiceApi: StocksApiServiceProtocol) {
        self.stocksServiceApi = stocksServiceApi
    }
}

extension StockQuotesViewModel: StockQuotesViewModelProtocol {
    
}
