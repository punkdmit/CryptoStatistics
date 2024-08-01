//
//  CoinAssembly.swift
//  CryptoStatistics
//
//  Created by Dmitry Apenko on 29.07.2024.
//

import Foundation

final class CoinAssembly: Assembly {
    
    private let coinCoordinator: Coordinator

    init(coinCoordinator: Coordinator) {
        self.coinCoordinator = coinCoordinator
    }

    func view(with name: String?) -> CoinViewController {
        let coinViewModel = CoinViewModel(
            networkService: NetworkService(),
            modelConversationService: ModelConversionService(),
            coinName: name ?? ""
        )
        let coinViewController = CoinViewController(coinViewModel: coinViewModel)
        return coinViewController
    }
}
