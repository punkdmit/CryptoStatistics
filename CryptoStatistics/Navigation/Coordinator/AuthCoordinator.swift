//
//  AuthCoordinator.swift
//  CryptoStatistics
//
//  Created by Dmitry Apenko on 23.06.2024.
//

import UIKit

protocol IAuthCoordinator: Coordinator {
    func goToListViewController()
    func goToListViewController(in window: UIWindow)
}

// MARK: - AuthCoordinator
final class AuthCoordinator: IAuthCoordinator {

    var childCoordinators: [any Coordinator] = []
    var navigationController: UINavigationController
    private let authContainer: AuthContainer

    init(      
        authContainer: AuthContainer,
        navigationController: UINavigationController
    ) {
        self.authContainer = authContainer
        self.navigationController = navigationController
    }
}

//MARK: - Internal methods
extension AuthCoordinator {
    
    func start(in window: UIWindow) {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        let authViewController = authContainer.makeAssembly(coordinator: self).view()
        navigationController.pushViewController(authViewController, animated: true)
    }

    func start() {
        navigationController.switchRootController(
            to: [authContainer.makeAssembly(coordinator: self).view()],
            animated: true,
            options: .transitionFlipFromLeft
        )
    }

    func goToListViewController() {
        let coinsListCoordinator = CoinsListCoordinator(
            navigationController: navigationController,
            coinsListContainer: CoinsListContainer()
        )
        childCoordinators.append(coinsListCoordinator)
        coinsListCoordinator.start()
    }

    /// вызывает метод start(in: window) если пользователь авторизован
    func goToListViewController(in window: UIWindow) {
        let coinsListCoordinator = CoinsListCoordinator(
            navigationController: navigationController,
            coinsListContainer: CoinsListContainer()
        )
        childCoordinators.append(coinsListCoordinator)
        coinsListCoordinator.start(in: window)
    }
}
