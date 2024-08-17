//
//  Coordinator.swift
//  CryptoStatistics
//
//  Created by Dmitry Apenko on 23.06.2024.
//

import UIKit

// MARK: - Coordinator
protocol Coordinator {
    
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    func start(in window: UIWindow?) throws
}

extension Coordinator {
    func start(in window: UIWindow? = nil) throws { }
}
