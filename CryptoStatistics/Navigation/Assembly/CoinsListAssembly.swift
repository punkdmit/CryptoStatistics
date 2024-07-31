//
//  CoinsListAssembly.swift
//  CryptoStatistics
//
//  Created by Dmitry Apenko on 26.07.2024.
//

import Foundation

final class CoinsListAssembly: Assembly {

    private let coinsListCoordinator: ICoinsListCoordinator

    init(coinsListCoordinator: ICoinsListCoordinator) {
        self.coinsListCoordinator = coinsListCoordinator
    }

    func view(with name: String? = nil) -> CoinsListViewController {
        let coinsListViewModel = CoinsListViewModel(
            coinsListCoordinator: coinsListCoordinator,
            modelConversationService: ModelConversionService(),
            networkService: NetworkService()
        )
        let coinsListViewController = CoinsListViewController(coinsListViewModel: coinsListViewModel)
        return coinsListViewController
    }
}
