//
//  AppContainer.swift
//  CryptoStatistics
//
//  Created by Dmitry Apenko on 25.07.2024.
//

import UIKit

final class AuthContainer: Container {

    func makeAssembly(coordinator: AuthCoordinator) -> AuthAssembly  {
        return AuthAssembly(authCoordinator: coordinator)
    }
}
