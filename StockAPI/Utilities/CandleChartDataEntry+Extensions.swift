//
//  CandleChartDataEntry+Extensions.swift
//  StockAPI
//
//  Created by Voro on 20.09.20.
//

import Foundation
import Charts

extension CandleChartDataEntry {
    convenience init(quote: Quote) {
        self.init()
        self.open = Double(quote.open)!
        self.high = Double(quote.high)!
        self.low = Double(quote.low)!
        self.close = Double(quote.close)!
    }
}

