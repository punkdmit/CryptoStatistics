//
//  CoinsListViewModel.swift
//  CryptoStatistics
//
//  Created by Dmitry Apenko on 30.06.2024.
//

import Foundation

//MARK: - CoinsListViewModel
final class CoinsListViewModel {

    // MARK: Constants

    private enum Constants {
        static let outputDateFormat = "dd.MM.yyyy hh:mm a"
    }

    var convertedCoinsArray: [CoinsListTableViewCellModel] = []

    //MARK: Private properties

    private let coinsListCoordinator: CoinsListCoordinator?
    private let modelConversationService: ModelConversionService?

    //MARK: Initialization

    init(
        coinsListCoordinator: CoinsListCoordinator,
        modelConversationService: ModelConversionService
    ) {
        self.coinsListCoordinator = coinsListCoordinator
        self.modelConversationService = modelConversationService
    }
}

//MARK: - CoinsListViewControllerDelegate
extension CoinsListViewModel: CoinsListViewControllerDelegate {

    func goToAuth() {
        coinsListCoordinator?.goToAuthViewController()
        StorageService.shared.save(isAuth: false)
    }
}

private extension CoinsListViewModel {

    func convertToLocaleModel(_ coinsListResponse: CoinsListResponse) -> CoinsListTableViewCellModel? {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.outputDateFormat
        let dateString = dateFormatter.string(from: date)
//        let localModel = CoinsListTableViewCellModel(from: coinsListResponse, with: dateString)
        let localModel = modelConversationService?.convertServerModelToApp(coinsListResponse, date: dateString)
        return localModel
    }
}
