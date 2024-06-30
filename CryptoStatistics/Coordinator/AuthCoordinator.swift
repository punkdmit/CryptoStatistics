//
//  AuthCoordinator.swift
//  CryptoStatistics
//
//  Created by Dmitry Apenko on 23.06.2024.
//

import UIKit

// MARK: - AuthCoordinator
final class AuthCoordinator: Coordinator {

    var childCoordinators: [any Coordinator] = []
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

//MARK: - Internal methods
extension AuthCoordinator {
    
    func start(in window: UIWindow) {
        let authViewModel = AuthViewModel(authCoordinator: self)
        let authViewController = AuthViewController(authViewModel: authViewModel)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        navigationController.pushViewController(authViewController, animated: true)
    }

    func goToListViewController() {
        let coinsListCoordinator = CoinsListCoordinator(navigationController: navigationController)
        childCoordinators.append(coinsListCoordinator)
        coinsListCoordinator.start()
    }

    /// вызывает метод start(in: window) если пользователь авторизован
    func goToListViewController(in window: UIWindow) {
        let coinsListCoordinator = CoinsListCoordinator(navigationController: navigationController)
        childCoordinators.append(coinsListCoordinator)
        coinsListCoordinator.start(in: window)
    }
}
