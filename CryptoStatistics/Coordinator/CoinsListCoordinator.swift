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

    private let transition = CATransition()

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

//MARK: - Internal methods
extension CoinsListCoordinator {

    func start() {
        let coinsListViewModel = CoinsListViewModel(coinsListCoordinator: self)
        let coinsListViewController = CoinsListViewController(coinsListViewModel: coinsListViewModel)
        coinsListViewController.delegate = coinsListViewModel
        navigationController.switchRootController(
            to: [coinsListViewController],
            animated: true,
            options: .transitionFlipFromRight
        )
//        navigationController.setViewControllers([coinsListViewController], animated: true)
    }

    /// метод если пользователь авторизован
    func start(in window: UIWindow) {
        let coinsListViewModel = CoinsListViewModel(coinsListCoordinator: self)
        let coinsListViewController = CoinsListViewController(coinsListViewModel: coinsListViewModel)
        coinsListViewController.delegate = coinsListViewModel
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        navigationController.pushViewController(coinsListViewController, animated: true)
    }

    /// возвращает на экран авторизации
    func goToAuthViewController() {
        let authCoordinator = AuthCoordinator(navigationController: navigationController)
        authCoordinator.start()
    }
}
