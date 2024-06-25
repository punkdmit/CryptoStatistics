//
//  Optional+extension.swift
//  CryptoStatistics
//
//  Created by Dmitry Apenko on 23.06.2024.
//

import UIKit

extension Optional where Wrapped == String {
  
  var isNotEmpty: Bool {
    return self != nil || self != ""
  }
}

extension UIStackView {
    func addArrangedSubviews( _ views: [UIView]) {
        views.forEach { view in
            addArrangedSubview(view)
        }
    }
}
