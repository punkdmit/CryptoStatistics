//
//  DIContainer.swift
//  CryptoStatistics
//
//  Created by Dmitry Apenko on 01.08.2024.
//

import Foundation

final class DIContainer {

    static let shared = DIContainer()
    private init() {}

    var dependencies = [String : AnyObject]()

    func register<T>(_ type: T.Type, _ object: T) {
        
    }
}
