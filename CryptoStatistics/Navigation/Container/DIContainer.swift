//
//  DIContainer.swift
//  CryptoStatistics
//
//  Created by Dmitry Apenko on 01.08.2024.
//

import Foundation

//MARK: - IDIContainer
protocol IDIContainer {
    func register<T>(_ type: T.Type, _ factory: @escaping () -> AnyObject)
    func resolve<T>(_ type: T.Type) throws -> T
}

//MARK: - DIContainer
final class DIContainer: IDIContainer {

    static let shared = DIContainer()
    private init() {}

    private let concurrentQueue = DispatchQueue(label: "queue", attributes: .concurrent)

    var dependencies = [String: () -> AnyObject]()

    func register<T>(_ type: T.Type, _ factory: @escaping () -> AnyObject) {
        concurrentQueue.async(flags: .barrier) {
            self.dependencies["\(type)"] = factory
        }
    }

    func resolve<T>(_ type: T.Type) throws -> T {
        try concurrentQueue.sync {
            guard let factory = dependencies["\(type)"], let dependency = factory() as? T else {
                throw DIContainerError.dependencyNotFound("Dependency error")
            }
            return dependency
        }
    }
}

