//
//  StockSymbol.swift
//  StockAPI
//
//  Created by Voro on 19.09.20.
//

import Foundation

enum StockSymbol: String, CaseIterable {
    case ibm = "IBM"
    case microsoft = "MSFT"
    case apple = "AAPL"
    case googleA = "GOOGL"
    case facebook = "FB"
    
    init?(value: String?) {
        guard let value = value else {
            return nil
        }
        
        self.init(rawValue: value)
    }
}
