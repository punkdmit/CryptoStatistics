//
//  TextFieldView.swift
//  CryptoStatistics
//
//  Created by Dmitry Apenko on 23.06.2024.
//

import Foundation
import UIKit

//MARK: TextFieldViewDelegate
protocol TextFieldViewDelegate: AnyObject {
    func textFieldDidBeginEditing(_ textField: UITextField)
    func textFieldDidEndEditing(_ textField: UITextField)
    func textFieldDidChangeSelection(_ textField: UITextField)
    func textFieldShouldBeginEditing(_ textField: UITextField)
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool
}

final class TextFieldView: UIView {

  // MARK: Constants

  private enum Constants {
    static let spacing: CGFloat = 2
  }

  weak var delegate: TextFieldViewDelegate?

  var placeholderText: String? {
    didSet {
      customTextField.placeholderText = placeholderText
    }
  }

  private lazy var stackView: UIStackView = {
    let stack = UIStackView()
    stack.spacing = Constants.spacing
    stack.axis = .vertical
    return stack
  }()

  private lazy var customTextField: CustomTextField = {
    let textField = CustomTextField()
    return textField
  }()

  private lazy var errorLabel: UILabel = {
    let label = UILabel()
    label.font = RegularFont.p3
    label.textColor = Assets.Colors.red
    return label
  }()

  init() {
    super.init(frame: .zero)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

extension TextFieldView {

  func showError(_ errorMessage: String?) {
    errorLabel.text = errorMessage
    customTextField.isError = errorMessage.isNotEmpty
    errorLabel.isHidden = !errorMessage.isNotEmpty
  }
}

extension TextFieldView: CustomTextFieldDelegate {

  func textFieldDidBeginEditing(_ textField: UITextField) {
    delegate?.textFieldDidBeginEditing(textField)
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    delegate?.textFieldDidEndEditing(textField)
  }
  
  func textFieldDidChangeSelection(_ textField: UITextField) {
    delegate?.textFieldDidChangeSelection(textField)
  }

  func textFieldShouldBeginEditing(_ textField: UITextField) {
    delegate?.textFieldShouldBeginEditing(textField)
  }
  
  func textField(
    _ textField: UITextField,
    shouldChangeCharactersIn range: NSRange,
    replacementString string: String
  ) -> Bool {
    customTextField.isError = false
    errorLabel.isHidden = true
    return delegate?.textField(
      textField,
      shouldChangeCharactersIn: range,
      replacementString: string
    ) ?? true
  }

}

private extension TextFieldView {

  func setupUI() {

    configureLayout()
  }

  func configureLayout() {
    addSubview(stackView)
    stackView.addArrangedSubview(customTextField)
    stackView.addArrangedSubview(errorLabel)

    stackView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }

}
