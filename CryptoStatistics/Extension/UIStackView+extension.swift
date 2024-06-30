//
//  UIStackView+extension.swift
//  CryptoStatistics
//
//  Created by Dmitry Apenko on 26.06.2024.
//

import UIKit

extension UIStackView {
    
    func addArrangesSubviews(_ views: [UIView]) {
        views.forEach { view in
            addArrangedSubview(view)
        }
    }
}
