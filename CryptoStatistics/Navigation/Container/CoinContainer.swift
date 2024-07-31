//
//  CoinContainer.swift
//  CryptoStatistics
//
//  Created by Dmitry Apenko on 29.07.2024.
//

import Foundation

final class CoinContainer: Container {

    func makeAssembly(coordinator: CoinCoordinator) -> CoinAssembly  {
        return CoinAssembly(coinCoordinator: coordinator)
    }
}
