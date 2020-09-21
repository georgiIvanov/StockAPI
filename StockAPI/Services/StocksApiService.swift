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
    func fetchStockQuotes(symbol: StockSymbol, timeframe: Timeframe) -> Single<[Quote]>
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
    func fetchStockQuotes(symbol: StockSymbol, timeframe: Timeframe) -> Single<[Quote]> {
        switch timeframe {
        case .daily:
            return fetchStockQuotes(endpoint: .stocksDaily(symbol: symbol),
                                    baseObjKey: "Time Series (Daily)")
        case .weekly:
            return fetchStockQuotes(endpoint: .stocksWeekly(symbol: symbol),
                                    baseObjKey: "Weekly Time Series")
        case .monthly:
            return fetchStockQuotes(endpoint: .stocksMonthly(symbol: symbol),
                                    baseObjKey: "Monthly Time Series")
        }
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
                quote1.timeStamp < quote2.timeStamp
            }
            
            return quotes
        }
    }
}
