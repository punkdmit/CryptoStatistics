//
//  CoinsListViewModel.swift
//  CryptoStatistics
//
//  Created by Dmitry Apenko on 30.06.2024.
//

import Foundation

//MARK: - CoinsListViewModel
final class CoinsListViewModel {

    //MARK: Private properties

    private let coinsListCoordinator: CoinsListCoordinator?

    //MARK: Initialization

    init(coinsListCoordinator: CoinsListCoordinator) {
        self.coinsListCoordinator = coinsListCoordinator
    }
}

//MARK: - CoinsListViewControllerDelegate
extension CoinsListViewModel: CoinsListViewControllerDelegate {

    func goToAuth() {
        coinsListCoordinator?.goToAuthViewController()
        StorageService.shared.save(isAuth: false)
    }
}
