//
//  NetworkError.swift
//  CryptoStatistics
//
//  Created by Dmitry Apenko on 06.07.2024.
//

import Foundation

enum NetworkError: Error {
    case urlError
    case requestError
    case noData
    case clientError(Int)
    case serverError(Int)
    case invalidResponseCode(Int)
    case responseError
    case decodingError
}
