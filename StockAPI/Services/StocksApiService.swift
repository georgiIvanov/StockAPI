//
//  StocksApiService.swift
//  StockAPI
//
//  Created by Voro on 19.09.20.
//

import Foundation
import RxSwift
import Moya

protocol StocksApiServiceProtocol: class {
    func fetchDailyQuotes() -> Single<Response>
}

class AlphaVantageApiService {
    let alphaVantageApi: AlphaVantageApi
    
    init(alphaVantageApi: AlphaVantageApi) {
        self.alphaVantageApi = alphaVantageApi
    }
}

extension AlphaVantageApiService: StocksApiServiceProtocol {
    func fetchDailyQuotes() -> Single<Response> {
        return alphaVantageApi.rx.request(.daily)
    }
}
