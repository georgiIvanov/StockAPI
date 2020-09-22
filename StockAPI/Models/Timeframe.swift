//
//  Timeframe.swift
//  StockAPI
//
//  Created by Voro on 21.09.20.
//

import Foundation

enum Timeframe: String, CaseIterable {
    case daily = "Daily"
    case weekly = "Weekly"
    case monthly = "Monthly"
    
    init?(value: String?) {
        guard let value = value else {
            return nil
        }
        
        self.init(rawValue: value)
    }
}
