//
//  Data+Extensions.swift
//  StockAPI
//
//  Created by Voro on 23.09.20.
//

import Foundation

extension Data {
    static func jsonData(fileName: String) -> Data? {
        let path = Bundle.main.path(forResource: fileName, ofType: "json")!
        let url = URL(string: "file://\(path)")!
        let data = try? Data(contentsOf: url)
        return data
    }
}
