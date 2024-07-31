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
    private let coinContainer: CoinContainer

    init(
        navigationController: UINavigationController,
        coinContainer: CoinContainer
    ) {
        self.navigationController = navigationController
        self.coinContainer = coinContainer
    }

    func start(with name: String) {
        let coinViewController = coinContainer.makeAssembly(coordinator: self).view(with: name)
        navigationController.pushViewController(coinViewController, animated: true)
    }
}
