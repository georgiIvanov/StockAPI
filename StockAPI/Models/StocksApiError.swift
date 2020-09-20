//
//  StocksApiError.swift
//  StockAPI
//
//  Created by Voro on 20.09.20.
//

import Foundation

enum StocksApiError: Error {
    case unableToSerializeResponseToJson
    case keyNotFound(key: String)
    case unexpectedModelFormat(obj: Any)
}
