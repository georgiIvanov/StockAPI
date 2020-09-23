//
//  AlphaVantageEndpoint.swift
//  StockAPI
//
//  Created by Voro on 19.09.20.
//

import Foundation
import Moya

typealias AlphaVantageApi = MoyaProvider<AlphaVantageEndpoint>

enum AlphaVantageEndpoint {
    case stocks(symbol: StockSymbol, timeframe: Timeframe)
}

extension AlphaVantageEndpoint: TargetType {
    var baseURL: URL {
        return URL(string: "https://\(AppConfig.stockApiBaseUrl)/")!
    }
    
    var path: String {
        switch self {
        case .stocks:
            return "query"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        switch self {
        case .stocks(let symbol, let timeframe):
            let fileName = "Stocks" + symbol.rawValue + timeframe.rawValue
            return Data.jsonData(fileName: fileName) ?? Data()
        }
    }
    
    var task: Task {
        switch self {
        case .stocks(let symbol, let timeframe):
            let params = buildStockQuoteParams(symbol: symbol, timeframe: timeframe)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}

private extension AlphaVantageEndpoint {
    func buildStockQuoteParams(symbol: StockSymbol, timeframe: Timeframe) -> [String: Any] {
        var params: [String: Any] = [
            "symbol": symbol.rawValue,
            "apikey": AppConfig.stockApiKey
        ]
        
        switch timeframe {
        case .daily:
            params["function"] = "TIME_SERIES_DAILY"
        case .weekly:
            params["function"] = "TIME_SERIES_WEEKLY"
        case .monthly:
            params["function"] = "TIME_SERIES_MONTHLY"
        }
        
        return params
    }
}
