//
//  AppConfig.swift
//  StockAPI
//
//  Created by Voro on 19.09.20.
//

import Foundation

struct AppConfig {
    
    static var apiBaseUrl: String {
        return "www.alphavantage.co"
    }
    
    static var stubResponses: Bool {
        return false
    }
    
}
