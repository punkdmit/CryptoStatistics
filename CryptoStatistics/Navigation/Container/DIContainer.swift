//
//  DIContainer.swift
//  CryptoStatistics
//
//  Created by Vadim Chistiakov on 31.07.2024.
//

import Foundation

// protocol NetworkService
// class DefaultNetworkService: NetworkService

final class DIContainer {
    static let shared = DIContainer()
    
    private var storage: [String: AnyObject] = [:]
    
    // Регистрирует объект по протоколу
    func register<T>(_ protocolType: T.Type, object: AnyObject) {
        storage["\(protocolType)"] = object
    }
    
    // Достает объект для заданного протокола
    func resovle<T>(_ protocolType: T.Type) -> T? {
        storage["\(protocolType)"] as? T
    }
    
}
