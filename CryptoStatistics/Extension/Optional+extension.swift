//
//  Optional+extension.swift
//  CryptoStatistics
//
//  Created by Dmitry Apenko on 23.06.2024.
//

import Foundation

extension Optional where Wrapped == String {

    var isNotEmpty: Bool {
        return self != nil || self != ""
    }
}
