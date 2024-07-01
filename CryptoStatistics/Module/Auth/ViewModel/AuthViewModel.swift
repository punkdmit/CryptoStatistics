//
//  AuthViewModel.swift
//  CryptoStatistics
//
//  Created by Dmitry Apenko on 27.06.2024.
//

import Foundation

protocol AuthViewModelDelegate: AnyObject {
    func showError(with message: String?, _ key: TextFieldType)
}

final class AuthViewModel {

    private enum DefaultValues {
        static let email = "1234"
        static let password = "1234"
    }

    var userLogin: String? = ""
    var userPassword: String? = ""

    weak var delegate: AuthViewModelDelegate?

    private let mainCoordinator: AuthCoordinator?

    init(authCoordinator: AuthCoordinator) {
        self.mainCoordinator = authCoordinator
    }

}

extension AuthViewModel {

    func moveToCoinsListViewController() {
        mainCoordinator?.goToListViewController()
    }
}

extension AuthViewModel: AuthViewControllerDelegate {

    func didTapButton() {
        var hasError = false
        if userLogin != DefaultValues.email {
            delegate?.showError(with: "userLogin", .login)
            hasError = true
        }
        
        if userPassword != DefaultValues.password {
            delegate?.showError(with: "userPassword", .password)
            hasError = true
        }
        
        if hasError {
            return
        }
        moveToCoinsListViewController()
        StorageService.shared.save(isAuth: true)
    }
}
