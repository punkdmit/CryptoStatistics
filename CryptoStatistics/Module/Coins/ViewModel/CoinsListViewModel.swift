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

//MARK: - ICoinsListViewModel
protocol ICoinsListViewModel {
    var convertedCoinsArray: [CoinsListTableViewCellModel] { get set }
    var didUpdateCoinsList: (() -> Void)? { get set }
    var switchViewState: ((_ state: CurrentState) -> Void)? { get set }
    func fetchCoins(_ reason: RequestReason)
    func sortCoins(by parameter: SortParameters)
    func goToAuth()
    func goToCoinViewController(with name: String)
}

//MARK: - CoinsListViewModel
final class CoinsListViewModel: ICoinsListViewModel {

    // MARK: Constants

    private enum Constants {
        static let outputDateFormat = "dd.MM.yyyy hh:mm a"
        static let coins = ["btc", "eth", "tron", "luna", "polkadot", "dogecoin", "tether", "stellar", "cardano", "xrp"]
    }

    var convertedCoinsArray: [CoinsListTableViewCellModel] = []

    var didUpdateCoinsList: (() -> Void)?
    var switchViewState: ((_ state: CurrentState) -> Void)?

    //MARK: Private properties

    private let coinsListCoordinator: CoinsListCoordinator?
    private let modelConversationService: IModelConversionService?
    private let networkService: INetworkService?
    private let delayManager = DelayManager()

    private let concurrentQueue = DispatchQueue(label: "queue", attributes: .concurrent)

    //MARK: Initialization

    init(
        coinsListCoordinator: CoinsListCoordinator,
        modelConversationService: IModelConversionService,
        networkService: INetworkService
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
            var temporaryCoinsArray: [CoinsListTableViewCellModel?] = Array(
                repeating: nil,
                count: Constants.coins.count
            )
            let group = DispatchGroup()
            for (index, coinName) in Constants.coins.enumerated() {
                group.enter()
                self.networkService?.getData(with: Endpoint.coin(coinName).url) { [weak self] (result: Result<CoinResponse, NetworkError>) in
                    guard let self = self else { return }
                    switch result {
                    case .success(let result):
                        let coinsListTableViewCellModel = convertToLocaleModel(result)
                        if let coinsListTableViewCellModel {
                            concurrentQueue.async(flags: .barrier) {
                                temporaryCoinsArray[index] = coinsListTableViewCellModel
                            }
                        }
                    case .failure(let error): /// проставить case для каждого типа ошибки !!!
                        print(error)
                    }
                    group.leave()
                }
            }
            group.notify(queue: .main) {
                self.concurrentQueue.sync {
                    self.convertedCoinsArray = temporaryCoinsArray.compactMap { $0 }
                }
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
            self.switchViewState?(.updated)
        }
    }

    func sortCoins(by parameter: SortParameters) {
        var currentCoinsList: [CoinsListTableViewCellModel] = []
        concurrentQueue.sync {
            currentCoinsList = convertedCoinsArray
        }
        var sortedCoinsList: [CoinsListTableViewCellModel]
        switch parameter {
        case .increasing:
            sortedCoinsList = currentCoinsList.sorted { $0.dayDynamicPercents < $1.dayDynamicPercents }
        case .reduce:
            sortedCoinsList = currentCoinsList.sorted { $0.dayDynamicPercents > $1.dayDynamicPercents }
        }
        concurrentQueue.async(flags: .barrier) { [weak self] in
            guard let self = self else { return }
            convertedCoinsArray = sortedCoinsList
        }
        didUpdateCoinsList?()
    }
}

//MARK: - Navigation
extension CoinsListViewModel {

    func goToAuth() {
        coinsListCoordinator?.goToAuthViewController()
        StorageService.shared.save(isAuth: false)
    }

    func goToCoinViewController(with name: String) {
        coinsListCoordinator?.goToCoinViewController(with: name)
    }
}

//MARK: - Private methods
private extension CoinsListViewModel {

    func convertToLocaleModel(_ coinsListResponse: CoinResponse) -> CoinsListTableViewCellModel? {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.outputDateFormat
        let dateString = dateFormatter.string(from: date)
        let localModel = modelConversationService?.convertServerCoinsModelToApp(coinsListResponse, date: dateString)
        return localModel
    }
}
