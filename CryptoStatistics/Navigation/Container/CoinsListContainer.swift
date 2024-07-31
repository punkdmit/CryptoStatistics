//
//  CoinsListContainer.swift
//  CryptoStatistics
//
//  Created by Dmitry Apenko on 27.07.2024.
//

import Foundation

final class CoinsListContainer: Container {

    func makeAssembly(coordinator: CoinsListCoordinator) -> CoinsListAssembly  {
        return CoinsListAssembly(coinsListCoordinator: coordinator)
    }
}
