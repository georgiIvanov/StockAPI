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
    case daily
    case weekly
    case monthly
}

extension AlphaVantageEndpoint: TargetType {
    var baseURL: URL {
        return URL(string: "https://\(AppConfig.apiBaseUrl)/")!
    }
    
    var path: String {
        switch self {
        case .daily, .weekly, .monthly:
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
        return .requestPlain
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
