//
//  CustomTextField.swift
//  CryptoStatistics
//
//  Created by Dmitry Apenko on 23.06.2024.
//

import UIKit
import SnapKit

// MARK: - CustomTextFieldDelegate
protocol CustomTextFieldDelegate: AnyObject {
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

// MARK: - TextFieldSize
enum TextFieldSize {
  case primary
}

// MARK: - Internal properties
extension TextFieldSize {

  var height: Int {
    switch self {
    case .primary:
      48
    }
  }
}

// MARK: - CustomTextField
final class CustomTextField: UITextField {

  // MARK: Constants

  private enum Constants {
    static let paddings = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
    static let boarderRadius: CGFloat = 23
    static let borderWidth: CGFloat = 1

    static let placeholderAttributes: [NSAttributedString.Key: Any] = [
      .font: SemiboldFont.h3,
      .foregroundColor: Assets.Colors.white
    ]
  }

  // MARK: Internal properties

  weak var customDelegate: CustomTextFieldDelegate?

  var placeholderText: String? {
    didSet {
      guard let placeholderText else { return }
      attributedPlaceholder = NSAttributedString(
        string: placeholderText,
        attributes: Constants.placeholderAttributes
      )
    }
  }

  var isError = false {
    didSet {
      guard isError else { return }
      layer.borderColor = Assets.Colors.red.cgColor
    }
  }

  // MARK: Private properties

  private let size: TextFieldSize

  // MARK: Initialization

  init(size: TextFieldSize = .primary) {
    self.size = size
    super.init(frame: .zero)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Internal methods
extension CustomTextField {

  override func textRect(forBounds bounds: CGRect) -> CGRect {
    bounds.inset(by: Constants.paddings)
  }

  override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
      bounds.inset(by: Constants.paddings)
  }

  override func editingRect(forBounds bounds: CGRect) -> CGRect {
      bounds.inset(by: Constants.paddings)
  }
}

// MARK: - UITextFieldDelegate
extension CustomTextField: UITextFieldDelegate {

  func textFieldDidBeginEditing(_ textField: UITextField) {
    customDelegate?.textFieldDidBeginEditing(textField)
  }

  func textFieldDidEndEditing(_ textField: UITextField) {
    customDelegate?.textFieldDidEndEditing(textField)
  }

  func textFieldDidChangeSelection(_ textField: UITextField) {
    customDelegate?.textFieldDidChangeSelection(textField)
  }

  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    customDelegate?.textFieldShouldBeginEditing(textField)
    return true
  }

  func textField(
      _ textField: UITextField,
      shouldChangeCharactersIn range: NSRange,
      replacementString string: String
  ) -> Bool {
    layer.borderColor = Assets.Colors.white.cgColor
    return customDelegate?.textField(
      textField,
      shouldChangeCharactersIn: range,
      replacementString: string
    ) ?? true
  }
}

// MARK: - Private methods
private extension CustomTextField {

  func setupUI() {
    delegate = self
    layer.cornerRadius = Constants.boarderRadius
    layer.borderWidth = Constants.borderWidth
    layer.borderColor = Assets.Colors.white.cgColor
    font = SemiboldFont.h3
    textColor = Assets.Colors.white
    configureLayout()
  }

  func configureLayout() {
    snp.makeConstraints {
      $0.height.equalTo(size.height)
    }
  }
}
