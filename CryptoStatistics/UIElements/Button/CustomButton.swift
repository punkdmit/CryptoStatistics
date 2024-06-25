//
//  CustomButton.swift
//  CryptoStatistics
//
//  Created by Dmitry Apenko on 24.06.2024.
//

import SnapKit
import UIKit

// MARK: - ButtonStyle
enum ButtonStyle {
  case primary
}

// MARK: - Internal properties
extension ButtonStyle {

  var normalBackgroundColor: UIColor {
    switch self {
    case .primary:
      Assets.Colors.white
    }
  }

  var highlightedBackgroundColor: UIColor {
    switch self {
    case .primary:
      Assets.Colors.grayLight
    }
  }

  var borderColor: CGColor {
    switch self {
    case .primary:
      Assets.Colors.grayLight.cgColor
    }
  }

  var labelColor: UIColor {
    switch self {
    case .primary:
      Assets.Colors.dark
    }
  }

  var hasBorder: Bool {
    self != .primary
  }
}

// MARK: - CustomButton

// UIButton.Configuration
// ButtonSize ButtonStyle are redundant

final class CustomButton: UIButton {
    
    // MARK: - ButtonSize
    enum ButtonSize {
        case primary
        
        var height: Int {
            switch self {
            case .primary:
                48
            }
        }
    }

  // MARK: Constants

  private enum Constants {
    static let borderWidth: CGFloat = 1
  }

  // MARK: Internal Properties

  var title: String = "" {
    didSet {
      setTitle(title)
    }
  }

  override var isHighlighted: Bool {
    didSet {
      isHighlighted
      ? setHighlighted()
      : setNotHighlighted()
    }
  }

  // MARK: Private Properties

  private let style: ButtonStyle
  private let size: ButtonSize

  // MARK: Initialization

  init(
    style: ButtonStyle = .primary,
    size: ButtonSize = .primary
  ) {
    self.style = style
    self.size = size
    super.init(frame: .zero)
    self.setupUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Life Cycle

  override func layoutSubviews() {
    super.layoutSubviews()
    layer.cornerRadius = bounds.height / 2
  }

}

// MARK: Private methods
private extension CustomButton {

  func setTitle(_ title: String) {
    setAttributedTitle(NSAttributedString(
      string: title,
      attributes: [.font: SemiboldFont.h3, .foregroundColor: style.labelColor]
    ), for: .normal)

    setAttributedTitle(NSAttributedString(
      string: title,
      attributes: [.font: SemiboldFont.h3, .foregroundColor: style.labelColor]
    ), for: .highlighted)
  }

  func setNotHighlighted() {
    backgroundColor = style.normalBackgroundColor
    layer.borderColor = style.borderColor
  }

  func setHighlighted() {
    backgroundColor = style.highlightedBackgroundColor
    layer.borderColor = style.borderColor
  }

  func setupUI() {
    layer.borderWidth = style.hasBorder ? Constants.borderWidth : 0
    setNotHighlighted()
    configureLayout()
  }

  func configureLayout() {
    snp.makeConstraints {
      $0.height.equalTo(size.height)
    }
  }
}
