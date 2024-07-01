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
        navigationController.setViewControllers([coinsListViewController], animated: true)
    }

    /// метод если пользователь авторизован
    func start(in window: UIWindow) {
        let coinsListViewModel = CoinsListViewModel(coinsListCoordinator: self)
        let coinsListViewController = CoinsListViewController(coinsListViewModel: coinsListViewModel)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        navigationController.pushViewController(coinsListViewController, animated: true)
    }

    /// возвращает на экран авторизации
    func goToAuthViewController() {
        let authCoordinator = AuthCoordinator(navigationController: navigationController)
        let authViewModel = AuthViewModel(authCoordinator: authCoordinator)
        let authViewController = AuthViewController(authViewModel: authViewModel)
//        transition.type = .push
//        transition.subtype = .fromLeft
//        navigationController.view.layer.add(transition, forKey: kCATransition)
        navigationController.switchRootController(to: authViewController, animated: true)
//        setViewControllers([authViewController], animated: false)
    }
}
