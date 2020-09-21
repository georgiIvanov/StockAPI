//
//  StockQuotesViewModel.swift
//  StockAPI
//
//  Created by Voro on 19.09.20.
//

import Foundation
import RxSwift

protocol StockQuotesViewModelProtocol: class {
    func fetchQuotes(symbol: StockSymbol, timeframe: Timeframe) -> Single<[Quote]>
}

class StockQuotesViewModel {
    let stocksServiceApi: StocksApiServiceProtocol
    
    init(stocksServiceApi: StocksApiServiceProtocol) {
        self.stocksServiceApi = stocksServiceApi
    }
}

extension StockQuotesViewModel: StockQuotesViewModelProtocol {
    func fetchQuotes(symbol: StockSymbol, timeframe: Timeframe) -> Single<[Quote]> {
        return stocksServiceApi.fetchStockQuotes(symbol: symbol, timeframe: timeframe)
    }
}
