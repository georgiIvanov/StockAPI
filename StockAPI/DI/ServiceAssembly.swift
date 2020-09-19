//
//  ServiceAssembly.swift
//  StockAPI
//
//  Created by Voro on 19.09.20.
//

import Foundation
import Swinject
import Moya
import Alamofire

class ServiceAssembly: Assembly {
    func assemble(container: Container) {
        registerApiProvider(into: container)

        container.register(StocksApiServiceProtocol.self) { (res) in
            return AlphaVantageApiService(alphaVantageApi: res.resolve(AlphaVantageApi.self)!)
        }
    }
}

private extension ServiceAssembly {
    func registerApiProvider(into container: Container) {
            container.register(AlphaVantageApi.self) { _ in

                let configuration = URLSessionConfiguration.default
                configuration.timeoutIntervalForRequest = 30
                configuration.timeoutIntervalForResource = 30
                configuration.requestCachePolicy = .useProtocolCachePolicy

                let manager = Session.init(configuration: configuration)

                if AppConfig.stubResponses {
                    return AlphaVantageApi(stubClosure: AlphaVantageApi.delayedStub(0.1),
                                          session: manager)
                } else {
                    return AlphaVantageApi(session: manager)
                }
            }.singleton()
        }
}
