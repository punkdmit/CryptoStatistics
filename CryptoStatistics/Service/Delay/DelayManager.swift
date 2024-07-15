//
//  DelayManager.swift
//  CryptoStatistics
//
//  Created by Dmitry Apenko on 14.07.2024.
//

import Foundation

class DelayManager {

    enum DelayType {
        case throttling(TimeInterval)
    }

    // MARK: Constants

    private enum Constants {
        static let interval: TimeInterval = 10
    }

    private var isRequestEnabled = true
    private let interval: TimeInterval = Constants.interval

    func performRequestIfNeeded(completion: @escaping () -> Void) -> Bool {
        guard isRequestEnabled else {
            print("Рано для нового запроса")
            return false
        }

        isRequestEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) { [weak self] in
            self?.isRequestEnabled = true
        }
        
        completion()
        return true
    }
}