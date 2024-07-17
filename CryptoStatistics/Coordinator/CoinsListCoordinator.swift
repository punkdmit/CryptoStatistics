//
//  CoinsListCoordinator.swift
//  CryptoStatistics
//
//  Created by Dmitry Apenko on 27.06.2024.
//

import UIKit

// MARK: - CoinsListCoordinator
final class CoinsListCoordinator: Coordinator {

    var childCoordinators: [any Coordinator] = []
    var navigationController: UINavigationController

//    private let transition = CATransition()

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

//MARK: - Internal methods
extension CoinsListCoordinator {

    func start() {
        let coinsListViewModel = CoinsListViewModel(
            coinsListCoordinator: self,
            modelConversationService: ModelConversionService(),
            networkService: NetworkService()
        )
        let coinsListViewController = CoinsListViewController(coinsListViewModel: coinsListViewModel)
        navigationController.switchRootController(
            to: [coinsListViewController],
            animated: true,
            options: .transitionFlipFromRight
        )
    }

    /// метод если пользователь авторизован
    func start(in window: UIWindow) {
        let coinsListViewModel = CoinsListViewModel(
            coinsListCoordinator: self,
            modelConversationService: ModelConversionService(),
            networkService: NetworkService()
        )
        let coinsListViewController = CoinsListViewController(coinsListViewModel: coinsListViewModel)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        navigationController.pushViewController(coinsListViewController, animated: true)
    }

    /// возвращает на экран авторизации
    func goToAuthViewController() {
        let authCoordinator = AuthCoordinator(navigationController: navigationController)
        authCoordinator.start()
    }

    func goToCoinViewController(with name: String) {
        let coinCoordinator = CoinCoordinator(navigationController: navigationController)
        childCoordinators.append(coinCoordinator)
        coinCoordinator.start(with: name)
    }
}
