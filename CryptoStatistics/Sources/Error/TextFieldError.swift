//
//  TextFieldError.swift
//  CryptoStatistics
//
//  Created by Dmitry Apenko on 30.06.2024.
//

import Foundation

enum TextFieldError: String, Error {
    case loginError = "Неверный логин"
    case passwordError = "Неверный пароль"
}
