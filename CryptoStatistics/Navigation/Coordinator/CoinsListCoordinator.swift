//
//  CoinsListCoordinator.swift
//  CryptoStatistics
//
//  Created by Dmitry Apenko on 27.06.2024.
//

import UIKit

protocol ICoinsListCoordinator: Coordinator {
    func goToAuthViewController()
    func goToCoinViewController(with name: String)
}

// MARK: - CoinsListCoordinator
final class CoinsListCoordinator: ICoinsListCoordinator {

    var childCoordinators: [any Coordinator] = []
    var navigationController: UINavigationController

    private let coinsListContainer: CoinsListContainer

    init(
        navigationController: UINavigationController,
        coinsListContainer: CoinsListContainer
    ) {
        self.navigationController = navigationController
        self.coinsListContainer = coinsListContainer
    }
}

//MARK: - Internal methods
extension CoinsListCoordinator {

    func start() {
        let coinsListViewController = coinsListContainer.makeAssembly(coordinator: self).view()
        navigationController.switchRootController(
            to: [coinsListViewController],
            animated: true,
            options: .transitionFlipFromRight
        )
    }

    /// метод если пользователь авторизован
    func start(in window: UIWindow) {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        let coinsListViewController = coinsListContainer.makeAssembly(coordinator: self).view()
        navigationController.pushViewController(coinsListViewController, animated: true)
    }

    /// возвращает на экран авторизации
    func goToAuthViewController() {
        let authCoordinator = AuthCoordinator(
            authContainer: AuthContainer(),
            navigationController: navigationController
        )
        authCoordinator.start()
    }

    func goToCoinViewController(with name: String) {
        let coinCoordinator = CoinCoordinator(
            navigationController: navigationController,
            coinContainer: CoinContainer()
        )
        childCoordinators.append(coinCoordinator)
        coinCoordinator.start(with: name)
    }
}
