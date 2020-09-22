//
//  ChartXAxisFormatter.swift
//  StockAPI
//
//  Created by Voro on 21.09.20.
//

import Foundation
import Charts

class ChartXAxisFormatter: IAxisValueFormatter {
    
    private var quotes: [Quote] = []
    private var timeframe: Timeframe?
    private var dateFormatter: DateFormatter
    
    init() {
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
    }
    
    func setQuotes(_ quotes: [Quote], timeframe: Timeframe) {
        self.quotes = quotes
        self.timeframe = timeframe
        
        switch timeframe {
        case .daily, .weekly:
            dateFormatter.dateFormat = "MM-dd"
        case .monthly:
            dateFormatter.dateFormat = "yyyy-MM"
        }
    }
    
    func stringForValue(_ value: Double,
                        axis: AxisBase?) -> String {
        let index = Int(value)
        
        guard index < quotes.count && index >= 0 else {
            print("Index out of bounds, will display it instead of time stamp")
            return "\(index)"
        }
        
        let quote = quotes[index]
        return dateFormatter.string(from: quote.timeStamp)
    }
}
