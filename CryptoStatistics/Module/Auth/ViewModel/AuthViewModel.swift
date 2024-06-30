//
//  AuthViewModel.swift
//  CryptoStatistics
//
//  Created by Dmitry Apenko on 27.06.2024.
//

import Foundation

protocol AuthViewModelDelegate: AnyObject {
    func showError(with message: String?)
}

final class AuthViewModel {

    private enum DefaultValues {
        static let email = "1234"
        static let password = "1234"
    }

    var userLogin: String? = ""
    var userPassword: String? = ""

    weak var delegate: AuthViewModelDelegate? {
        didSet {
            delegate?.showError(with: errorMessage/*, key: key*/)
        }
    }

    private var errorMessage: String? {
        didSet {
            delegate?.showError(with: errorMessage/*, key: key*/)
        }
    }
//    private var key: TextFieldType

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

    func didTapButton() throws {
        guard userLogin == DefaultValues.email else {
            throw TextFieldError.loginError
//            return
        }
        guard userPassword == DefaultValues.password else {
            throw TextFieldError.passwordError
//            return
        }
        moveToCoinsListViewController()
        StorageService.shared.save(isAuth: true)
    }
}
