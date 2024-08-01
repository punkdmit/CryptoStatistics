//
//  Assembly.swift
//  CryptoStatistics
//
//  Created by Dmitry Apenko on 26.07.2024.
//

import UIKit

protocol Assembly {
    associatedtype Controller: UIViewController
    func view(with name: String?) -> Controller
}
