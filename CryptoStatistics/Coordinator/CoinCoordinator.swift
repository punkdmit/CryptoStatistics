//
//  CoinCoordinator.swift
//  CryptoStatistics
//
//  Created by Dmitry Apenko on 15.07.2024.
//

import UIKit

final class CoinCoordinator: Coordinator {

    var childCoordinators: [any Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start(with name: String) {
        let coinViewModel = CoinViewModel(networkService: NetworkService(), modelConversationService: ModelConversionService(), coinName: name)
//        coinViewModel.fetchCoin(with: name)
        let coinViewController = CoinViewController(coinViewModel: coinViewModel)
        navigationController.pushViewController(coinViewController, animated: true)
    }
}
