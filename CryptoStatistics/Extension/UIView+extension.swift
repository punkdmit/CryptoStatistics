//
//  UIView+extension.swift
//  CryptoStatistics
//
//  Created by Dmitry Apenko on 26.06.2024.
//

import UIKit

extension UIView {
    
    func addSubviews(_ subviews: [UIView]) {
        subviews.forEach { view in
            addSubview(view)
        }
    }
}
