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

protocol IAuthViewModel {
    var userLogin: String? { get set }
    var userPassword: String? { get set }
    func didTapButton() throws
}

final class AuthViewModel: IAuthViewModel {

    private enum DefaultValues {
        static let email = "1234"
        static let password = "1234"
    }

    var userLogin: String? = ""
    var userPassword: String? = ""

    weak var delegate: AuthViewModelDelegate?

    private let authCoordinator: IAuthCoordinator

    init(authCoordinator: IAuthCoordinator) {
        self.authCoordinator = authCoordinator
    }

}

extension AuthViewModel {

    func didTapButton() throws {
        var hasError = false
        if userLogin != DefaultValues.email {
            delegate?.showError(with: TextFieldError.loginError.rawValue, .login)
            hasError = true
        }
        if userPassword != DefaultValues.password {
            delegate?.showError(with: TextFieldError.passwordError.rawValue, .password)
            hasError = true
        }
        guard !hasError else { return }
        moveToCoinsListViewController()
        StorageService.shared.save(isAuth: true)
    }

    func moveToCoinsListViewController() {
        authCoordinator.goToListViewController()
    }
}
