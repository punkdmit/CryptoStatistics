//
//  ScreenState.swift
//  CryptoStatistics
//
//  Created by Dmitry Apenko on 17.07.2024.
//

import Foundation

// MARK: - Screen States
enum CurrentState {
    case loading
    case loaded
    case updated
    case failed(errorMessage: String)
}
