//
//  Assembly.swift
//  CryptoStatistics
//
//  Created by Dmitry Apenko on 26.07.2024.
//

import UIKit

protocol Assembly {
    associatedtype Controller: UIViewController
    associatedtype CoordinatorType: Coordinator
    func view(with name: String?) throws -> Controller
    func setCoordinator(_ coordinator: CoordinatorType?)
}
