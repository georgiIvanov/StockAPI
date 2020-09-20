//
//  Quote.swift
//  StockAPI
//
//  Created by Voro on 19.09.20.
//

import Foundation

struct Quote: Codable {
    let open: String
    let high: String
    let low: String
    let close: String
    let volume: String?
    
    // YYYY-MM-DD
    let timeStamp: Date
    
}

extension Quote {
    init(from dict: [String: String], timeStamp: String, dateFormatter: DateFormatter) throws {
        guard let open = dict["1. open"],
              let high = dict["2. high"],
              let low = dict["3. low"],
              let close = dict["4. close"] else {
            throw StocksApiError.unexpectedModelFormat(obj: dict)
        }
        
        self.open = open
        self.high = high
        self.low = low
        self.close = close
        
        if let date = dateFormatter.date(from: timeStamp) {
            self.timeStamp = date
        } else {
            throw StocksApiError.unexpectedModelFormat(obj: timeStamp)
        }
        
        self.volume = dict["5. volume"]
    }
}
