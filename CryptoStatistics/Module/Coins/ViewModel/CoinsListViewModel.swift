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

    var convertedCoinsArray: [CoinsListTableViewCellModel]? {
        didSet {
            self.didUpdateCoinsList?()
        }
    }

    var didUpdateCoinsList: (() -> Void)?

    //MARK: Private properties

    private let coinsListCoordinator: CoinsListCoordinator?
    private let modelConversationService: ModelConversionService?
    private let networkService: NetworkService?

    //MARK: Initialization

    init(
        coinsListCoordinator: CoinsListCoordinator,
        modelConversationService: ModelConversionService,
        networkService: NetworkService
    ) {
        self.coinsListCoordinator = coinsListCoordinator
        self.modelConversationService = modelConversationService
        self.networkService = networkService
    }
}

//MARK: - Networking methods
extension CoinsListViewModel {

    func fetchCoin(with endpoint: Endpoint) {
        networkService?.getData(with: endpoint.url) { [weak self] (result: Result<CoinsListResponse, NetworkError>) in
            guard let self else { return }
            switch result {
            case .success(let result):
                let coinsListTableViewCellModel = convertToLocaleModel(result)
                if let coinsListTableViewCellModel = coinsListTableViewCellModel {
                    convertedCoinsArray?.append(coinsListTableViewCellModel)
                }
            case .failure(let error): /// проставить case для каждого типа ошибки !!!
                print(error)
            }
        }
    }
}

//MARK: - CoinsListViewControllerDelegate
extension CoinsListViewModel: CoinsListViewControllerDelegate {

    func goToAuth() {
        coinsListCoordinator?.goToAuthViewController()
        StorageService.shared.save(isAuth: false)
    }
}

//MARK: - Private methods
private extension CoinsListViewModel {

    func convertToLocaleModel(_ coinsListResponse: CoinsListResponse) -> CoinsListTableViewCellModel? {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.outputDateFormat
        let dateString = dateFormatter.string(from: date)
        let localModel = modelConversationService?.convertServerModelToApp(coinsListResponse, date: dateString)
        return localModel
    }
}
