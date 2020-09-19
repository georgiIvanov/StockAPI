//
//  DIContainer.swift
//  StockAPI
//
//  Created by Voro on 19.09.20.
//

import Foundation
import Swinject

protocol DIContainer: class {
    static var container: Container { get }
    static func createContainer() -> Container
}

extension DIContainer where Self: AppDelegate {

    static func createContainer() -> Container {
        Container.loggingFunction = nil

        let container = Container()
        _ = Assembler([ViewControllerAssembly()], container: container)
        return container
    }
}

extension AppDelegate: DIContainer {

    static let container: Container = {
        return createContainer()
    }()

}

extension ServiceEntry {
    func singleton() {
        inObjectScope(.container)
    }
}
