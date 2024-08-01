//
//  AuthAssembly.swift
//  CryptoStatistics
//
//  Created by Dmitry Apenko on 25.07.2024.
//

import UIKit

final class AuthAssembly: Assembly {

    private let authCoordinator: IAuthCoordinator

    init(authCoordinator: IAuthCoordinator) {
        self.authCoordinator = authCoordinator
    }

    func view(with name: String? = nil) -> AuthViewController {
        let authViewModel = AuthViewModel(authCoordinator: authCoordinator)
        let authViewController = AuthViewController(authViewModel: authViewModel)
        authViewModel.delegate = authViewController
        return authViewController
    }
}
