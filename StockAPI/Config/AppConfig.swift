//
//  AppConfig.swift
//  StockAPI
//
//  Created by Voro on 19.09.20.
//

import Foundation

struct AppConfig {
    
    static var stockApiBaseUrl: String {
        return configValue(for: "STOCK_API_BASE_URL")
    }
    
    static var stockApiKey: String {
        return configValue(for: "STOCK_API_KEY")
    }
    
    static var stubResponses: Bool {
        return configValue(for: "STUB_RESPONSE")
    }
    
    static func configValue<T>(for key: String) -> T where T: LosslessStringConvertible {
        guard let object = Bundle.main.object(forInfoDictionaryKey: key) else {
            fatalError("Missing Info.plist key: \(key)")
        }

        switch object {
        case let value as T:
            return value
        case let string as String:
            guard let value = T(string) else { fallthrough }
            return value
        default:
            fatalError("Invalid value with key: \(key)")
        }
    }
}
