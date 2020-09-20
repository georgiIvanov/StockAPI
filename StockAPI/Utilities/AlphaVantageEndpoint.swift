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
    case stocksDaily(symbol: StockSymbol)
    case stocksWeekly(symbol: StockSymbol)
    case stocksMonthly(symbol: StockSymbol)
}

extension AlphaVantageEndpoint: TargetType {
    var baseURL: URL {
        return URL(string: "https://\(AppConfig.stockApiBaseUrl)/")!
    }
    
    var path: String {
        switch self {
        case .stocksDaily, .stocksWeekly, .stocksMonthly:
            return "query"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .stocksDaily(let symbol), .stocksWeekly(let symbol), .stocksMonthly(let symbol):
            let params = buildStockQuoteParams(symbol: symbol, endpoint: self)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}

private extension AlphaVantageEndpoint {
    func buildStockQuoteParams(symbol: StockSymbol, endpoint: AlphaVantageEndpoint) -> [String: Any] {
        var params: [String: Any] = [
            "symbol": symbol.rawValue,
            "apikey": AppConfig.stockApiKey
        ]
        
        switch endpoint {
        case .stocksDaily:
            params["function"] = "TIME_SERIES_DAILY"
        case .stocksWeekly:
            params["function"] = "TIME_SERIES_WEEKLY"
        case .stocksMonthly:
            params["function"] = "TIME_SERIES_MONTHLY"
        }
        
        return params
    }
}
