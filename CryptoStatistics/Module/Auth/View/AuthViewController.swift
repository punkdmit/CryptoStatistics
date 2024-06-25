//
//  AuthViewController.swift
//  CryptoStatistics
//
//  Created by Dmitry Apenko on 22.06.2024.
//

import UIKit
import SnapKit

final class AuthViewController: UIViewController {

  // MARK: Constants

  private enum Constants {
    static let loginTextFieldText = "Login"
    static let passwordTextFieldText = "Password"
    static let buttonText = "Go"

  }

  private lazy var loginTextFieldView: TextFieldView = {
    let textFieldView = TextFieldView()
    textFieldView.placeholderText = Constants.loginTextFieldText
    textFieldView.showError("test error")
    return textFieldView
  }()

  private lazy var passwordTextFieldView: TextFieldView = {
    let textFieldView = TextFieldView()
    textFieldView.placeholderText = Constants.passwordTextFieldText
    textFieldView.showError("test error")
    return textFieldView
  }()

  private lazy var buttonView: CustomButton = {
    let button = CustomButton()
    button.title = Constants.buttonText
    return button
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }

}

private extension AuthViewController {

  func setupUI() {
    view.backgroundColor = Assets.Colors.dark
    configureLayout()
  }

  func configureLayout() {
    let textFieldStack = UIStackView(arrangedSubviews: [loginTextFieldView, passwordTextFieldView])
    textFieldStack.axis = .vertical
    textFieldStack.spacing = AppConstants.normalSpacing

    view.addSubview(textFieldStack)
    view.addSubview(buttonView)

//    loginTextFieldView.snp.makeConstraints {
//      $0.center.equalToSuperview()
//      $0.leading.trailing.equalToSuperview().inset(AppConstants.normalSpacing)
//    }
//
//    passwordTextFieldView.snp.makeConstraints {
//      $0.centerX.equalToSuperview()
//      $0.leading.trailing.equalToSuperview().inset(AppConstants.normalSpacing)
//      $0.top.equalTo(loginTextFieldView.snp.bottom).offset(AppConstants.normalSpacing)
//    }

    textFieldStack.snp.makeConstraints {
      $0.center.equalToSuperview()
      $0.leading.trailing.equalToSuperview().inset(AppConstants.normalSpacing)
    }

    buttonView.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.leading.trailing.equalToSuperview().inset(AppConstants.normalSpacing)
      $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(AppConstants.normalSpacing)
    }
  }
}
