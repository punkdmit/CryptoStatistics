//
//  Container.swift
//  CryptoStatistics
//
//  Created by Dmitry Apenko on 26.07.2024.
//

import Foundation

protocol Container {
    associatedtype AssemblyType: Assembly
    associatedtype CoordinatorType: Coordinator
    func makeAssembly(coordinator: CoordinatorType) -> AssemblyType
}
