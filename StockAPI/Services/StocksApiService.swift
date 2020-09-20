//
//  StocksApiService.swift
//  StockAPI
//
//  Created by Voro on 19.09.20.
//

import Foundation
import RxSwift
import Moya

protocol StocksApiServiceProtocol: class {
    func fetchDailyStockQuotes(symbol: StockSymbol) -> Single<[Quote]>
    func fetchWeeklyStockQuotes(symbol: StockSymbol) -> Single<[Quote]>
    func fetchMonthlyStockQuotes(symbol: StockSymbol) -> Single<[Quote]>
}

class AlphaVantageApiService {
    let alphaVantageApi: AlphaVantageApi
    let dateFormatter: DateFormatter
    
    init(alphaVantageApi: AlphaVantageApi) {
        self.alphaVantageApi = alphaVantageApi
        self.dateFormatter = DateFormatter()
        self.dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        self.dateFormatter.dateFormat = "yyyy-MM-dd"
    }
}

extension AlphaVantageApiService: StocksApiServiceProtocol {
    
    func fetchDailyStockQuotes(symbol: StockSymbol) -> Single<[Quote]> {
        return fetchStockQuotes(endpoint: .stocksDaily(symbol: symbol),
                                baseObjKey: "Time Series (Daily)")
    }
    
    func fetchWeeklyStockQuotes(symbol: StockSymbol) -> Single<[Quote]> {
        return fetchStockQuotes(endpoint: .stocksWeekly(symbol: symbol),
                                baseObjKey: "Weekly Time Series")
    }
    
    func fetchMonthlyStockQuotes(symbol: StockSymbol) -> Single<[Quote]> {
        return fetchStockQuotes(endpoint: .stocksMonthly(symbol: symbol),
                                baseObjKey: "Monthly Time Series")
    }
}

extension AlphaVantageApiService {
    func fetchStockQuotes(endpoint: AlphaVantageEndpoint, baseObjKey: String) -> Single<[Quote]> {
        return alphaVantageApi.rx.request(endpoint).map { (resp) in
            
            guard let decoded = try JSONSerialization.jsonObject(with: resp.data,
                                                                 options: .allowFragments) as? [String: Any] else {
                throw StocksApiError.unableToSerializeResponseToJson
            }
            
            guard let quotesDict = decoded[baseObjKey] as? [String: Any] else {
                throw StocksApiError.keyNotFound(key: baseObjKey)
            }
            
            var quotes: [Quote] = []
            for (key, value) in quotesDict {
                guard let dict = value as? [String: String] else {
                    throw StocksApiError.unexpectedModelFormat(obj: value)
                }
                let quote = try Quote(from: dict, timeStamp: key, dateFormatter: self.dateFormatter)
                quotes.append(quote)
            }
            
            quotes.sort { (quote1, quote2) in
                quote1.timeStamp > quote2.timeStamp
            }
            
            return quotes
        }
    }
}
