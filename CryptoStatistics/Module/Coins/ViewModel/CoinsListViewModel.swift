//
//  CoinsListViewModel.swift
//  CryptoStatistics
//
//  Created by Dmitry Apenko on 30.06.2024.
//

import Foundation

//MARK: - SortParameters
enum SortParameters {
    case increasing
    case reduce
}

//MARK: - CoinsListViewModel
final class CoinsListViewModel {

    // MARK: Constants

    private enum Constants {
        static let outputDateFormat = "dd.MM.yyyy hh:mm a"

        static let coins = ["btc", "eth", "tron", "luna", "polkadot", "dogecoin", "tether", "stellar", "cardano", "xrp"]
    }

    var convertedCoinsArray: [CoinsListTableViewCellModel?] = Array(
        repeating: nil,
        count: Constants.coins.count
    )

    var didUpdateCoinsList: (() -> Void)?
    var switchViewState: ((_ state: CurrentState) -> Void)?

    //MARK: Private properties

    private let coinsListCoordinator: CoinsListCoordinator?
    private let modelConversationService: ModelConversionService?
    private let networkService: NetworkService?

    private let delayManager = DelayManager()

    private let concurrentQueue = DispatchQueue(label: "queue", attributes: .concurrent)

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

    func fetchCoins(_ reason: RequestReason) {
        let isRequestEnabled = delayManager.performRequestIfNeeded { [weak self] in
            guard let self = self else { return }
            if reason == .firstLoad {
                switchViewState?(.loading)
            }
            let group = DispatchGroup()
            for (index, coinName) in Constants.coins.enumerated() {
                group.enter()
                self.networkService?.getData(with: Endpoint.coin(coinName).url) { [weak self] (result: Result<CoinsListResponse, NetworkError>) in
                    guard let self else { return }
                    switch result {
                    case .success(let result):
                        let coinsListTableViewCellModel = convertToLocaleModel(result)
                        if let coinsListTableViewCellModel = coinsListTableViewCellModel {
                            concurrentQueue.async(flags: .barrier) {
                                self.convertedCoinsArray[index] = coinsListTableViewCellModel
                            }
                        }
                    case .failure(let error): /// проставить case для каждого типа ошибки !!!
                        print(error)
                    }
                    group.leave()
                }
            }
            group.notify(queue: .main) {
                self.didUpdateCoinsList?()
                switch reason {
                case .firstLoad:
                    self.switchViewState?(.loaded)
                case .update:
                    self.switchViewState?(.updated)
                }
            }
        }
        if !isRequestEnabled {
            self.switchViewState?(.failed)
        }
    }

    func sortCoins(by parameter: SortParameters) {
        var currentCoinsList: [CoinsListTableViewCellModel?] = []
        concurrentQueue.sync {
            currentCoinsList = convertedCoinsArray
        }
        var sortedCoinsList: [CoinsListTableViewCellModel?]
        switch parameter {
        case .increasing:
            sortedCoinsList = currentCoinsList.sorted { $0?.dayDynamicPercents ?? 0 < $1?.dayDynamicPercents ?? 0}
        case .reduce:
            sortedCoinsList = currentCoinsList.sorted { $0?.dayDynamicPercents ?? 0 > $1?.dayDynamicPercents ?? 0}
        }
        concurrentQueue.async(flags: .barrier) { [weak self] in
            guard let self = self else { return }
            convertedCoinsArray = sortedCoinsList
        }
        didUpdateCoinsList?()
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
