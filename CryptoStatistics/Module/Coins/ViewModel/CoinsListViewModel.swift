//
//  CoinsListViewModel.swift
//  CryptoStatistics
//
//  Created by Dmitry Apenko on 30.06.2024.
//

import Foundation
import CoreData
import Combine

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

//    func fetchCoinsFromNetwork(_ reason: RequestReason)
    func fetchCoins(_ reason: RequestReason) async throws
    var coinsListPublisher: AnyPublisher<[CoinsListTableViewCellModel], NetworkError> { get }
//    func fetchCoinsCombine(_ reason: RequestReason)

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

    //MARK: Combine

    private let coinsListSubject = PassthroughSubject<[CoinsListTableViewCellModel], NetworkError>()
    var coinsListPublisher: AnyPublisher<[CoinsListTableViewCellModel], NetworkError> {
        return coinsListSubject.eraseToAnyPublisher()
    }

    //MARK: Completion

    var didUpdateCoinsList: (() -> Void)?
    var switchViewState: ((_ state: CurrentState) -> Void)?

    //MARK: Private properties

    private let coinsListCoordinator: ICoinsListCoordinator
    private let modelConversationService: IModelConversionService
    private let networkService: INetworkService
    private let delayManager: IDelayManager
    private let storageService: IStorageService
    private let coinService: ICoinService
    private let coreDataService: ICoreDataService

    private let concurrentQueue = DispatchQueue(label: "queue", attributes: .concurrent)
    private var cancellable = Set<AnyCancellable>()

    //MARK: Initialization

    init(
        coinsListCoordinator: ICoinsListCoordinator,
        modelConversationService: IModelConversionService,
        networkService: INetworkService,
        delayManager: IDelayManager,
        storageService: IStorageService,
        coinService: ICoinService,
        coreDataService: ICoreDataService
    ) {
        self.coinsListCoordinator = coinsListCoordinator
        self.modelConversationService = modelConversationService
        self.networkService = networkService
        self.delayManager = delayManager
        self.storageService = storageService
        self.coinService = coinService
        self.coreDataService = coreDataService
    }
}

//MARK: - Networking methods
extension CoinsListViewModel {

    func fetchCoins(_ reason: RequestReason) {
        switch reason {
        case .firstLoad:
            let isAuth = storageService.load()
            switch isAuth {
            case true:
                fetchCoinFromCoreData()
            case false:
                fetchCoinsFromNetwork(reason)
            }
        case .update:
            fetchCoinsFromNetwork(reason)
        }
    }

    func fetchCoinsCombine(_ reason: RequestReason) {
        let publishers = Constants.coins.enumerated().map { (index, name) in
            return coinService.fetchCoin(.coin(name))
                .map { coin -> (Int, CoinResponse) in
                    return (index, coin)
                }
                .eraseToAnyPublisher()
        }

        Publishers.MergeMany(publishers)
            .collect()
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        break
                    }
                },
                receiveValue: { [weak self] response in
                    guard let self = self else { return }
                    var temporaryCoinsArray: [CoinsListTableViewCellModel?] = Array(
                        repeating: nil,
                        count: Constants.coins.count
                    )

                    for (index, coin) in response {
                        let convertedCoin = convertToLocaleModel(coin)
                        concurrentQueue.async(flags: .barrier) {
                            temporaryCoinsArray[index] = convertedCoin
                        }
                    }
                    coinsListSubject.send(temporaryCoinsArray.compactMap { $0 })
                }
            )
            .store(in: &cancellable)
        }

    func fetchCoins(_ reason: RequestReason) async throws {
        let isRequestEnabled = delayManager.performRequestIfNeeded { [weak self] in
            guard let self = self else { return }
            if reason == .firstLoad {
                switchViewState?(.loading)
            }
        }
        if !isRequestEnabled {
            self.switchViewState?(.updated)
        }

        var temporaryCoinsArray = try await withThrowingTaskGroup(
            of: (Int, CoinsListTableViewCellModel?).self,
            returning: [(Int, CoinsListTableViewCellModel?)].self
        ) { [weak self] taskGroup in
            guard let self = self else { return [] }
            for (index, name) in Constants.coins.enumerated() {
                taskGroup.addTask {
                    do {
                        let coin = try await self.coinService.fetchCoin(.coin(name))
                        let coinsListTableViewCellModel = self.convertToLocaleModel(coin)
                        return (index, coinsListTableViewCellModel)
                    } catch {
                        if let error = error as? NetworkError {
                            switch error {
                            case .clientError(let value):
                                guard value != 404, value != 429 else { break } // появляются из за бека
                                self.switchViewState?(.failed(errorMessage: "Проверьте подключение"))
                            case .decodingError, .noData, .responseError, .urlError, .requestError:
                                self.switchViewState?(.failed(errorMessage: "Проблема. Уже исправляем"))
                            case .serverError(_):
                                self.switchViewState?(.failed(errorMessage: "Ошибка на сервере"))
                            case .invalidResponseCode(_):
                                self.switchViewState?(.failed(errorMessage: "Ошибка на сервере"))
                            }
                        }
                        throw error
                    }
                }
            }

            var results: [(Int, CoinsListTableViewCellModel?)] = []
            for try await result in taskGroup {
                results.append(result)
            }
            switch reason {
            case .firstLoad:
                switchViewState?(.loaded)
            case .update:
                self.switchViewState?(.updated)
            }
            return results
        }

        convertedCoinsArray = temporaryCoinsArray
                                .sorted(by: { $0.0 < $1.0 })
                                .map { $0.1 }
                                .compactMap { $0 }
    }
}

//MARK: - Private networking methods
private extension CoinsListViewModel {

    func fetchCoinsFromNetwork(_ reason: RequestReason) {
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
                self.networkService.getData(with: Endpoint.coin(coinName).url) { [weak self] (result: Result<CoinResponse, NetworkError>) in
                    guard let self = self else { return }
                    switch result {
                    case .success(let result):

                        let coinsListTableViewCellModel = convertToLocaleModel(result)
                        if let coinsListTableViewCellModel {
                            concurrentQueue.async(flags: .barrier) {
                                temporaryCoinsArray[index] = coinsListTableViewCellModel
                            }
                        }
                    case .failure(let error):
                        switch error {
                        case .clientError(let value):
                            guard value != 404, value != 429 else { break } // появляются из за бека
                            switchViewState?(.failed(errorMessage: "Проверьте подключение"))
                        case .decodingError, .noData, .responseError, .urlError, .requestError:
                            switchViewState?(.failed(errorMessage: "Проблема. Уже исправляем"))
                        case .serverError(_):
                            switchViewState?(.failed(errorMessage: "Ошибка на сервере"))
                        case .invalidResponseCode(_):
                            switchViewState?(.failed(errorMessage: "Ошибка на сервере"))
                        }
                    }
                    group.leave()
                }
            }
            group.notify(queue: .main) {
                self.concurrentQueue.sync {
                    self.convertedCoinsArray = temporaryCoinsArray.compactMap { $0 }
                }
                self.saveCoinToCoreData(self.convertedCoinsArray)
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
}

//MARK: - Navigation
extension CoinsListViewModel {

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

    func goToAuth() {
        do {
            try coinsListCoordinator.goToAuthViewController()
        } catch {
            print(error)
        }
        storageService.save(isAuth: false)

    }

    func goToCoinViewController(with name: String) {
        do {
            try coinsListCoordinator.goToCoinViewController(with: name)
        } catch {
            print(error)
        }
    }
}

//MARK: - Private methods
private extension CoinsListViewModel {

    func convertToLocaleModel(_ coinsListResponse: CoinResponse) -> CoinsListTableViewCellModel? {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.outputDateFormat
        let dateString = dateFormatter.string(from: date)
        let localModel = modelConversationService.convertServerCoinsModelToApp(coinsListResponse, date: dateString)
        return localModel
    }
}

//MARK: - CoreData
private extension CoinsListViewModel {

    func saveCoinToCoreData(_ coins: [CoinsListTableViewCellModel]) {
        coreDataService.saveCoinToCoreData(coins)
    }

    func fetchCoinFromCoreData() {
        do {
            try coreDataService.fetchCoinFromCoreData { coins in
                concurrentQueue.async(flags: .barrier) { [weak self] in
                    self?.convertedCoinsArray = coins
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
