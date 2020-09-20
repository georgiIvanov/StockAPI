//
//  StockQuotesViewModel.swift
//  StockAPI
//
//  Created by Voro on 19.09.20.
//

import Foundation
import RxSwift

protocol StockQuotesViewModelProtocol: class {
    func fetchDailyQuotes(symbol: StockSymbol) -> Single<[Quote]>
    func fetchWeeklyQuotes(symbol: StockSymbol) -> Single<[Quote]>
    func fetchMonthlyQuotes(symbol: StockSymbol) -> Single<[Quote]>
}

class StockQuotesViewModel {
    let stocksServiceApi: StocksApiServiceProtocol
    
    init(stocksServiceApi: StocksApiServiceProtocol) {
        self.stocksServiceApi = stocksServiceApi
    }
}

extension StockQuotesViewModel: StockQuotesViewModelProtocol {
    func fetchDailyQuotes(symbol: StockSymbol) -> Single<[Quote]> {
        return stocksServiceApi.fetchDailyStockQuotes(symbol: symbol)
    }
    
    func fetchWeeklyQuotes(symbol: StockSymbol) -> Single<[Quote]> {
        return stocksServiceApi.fetchWeeklyStockQuotes(symbol: symbol)
    }
    
    func fetchMonthlyQuotes(symbol: StockSymbol) -> Single<[Quote]> {
        return stocksServiceApi.fetchMonthlyStockQuotes(symbol: symbol)
    }
}
