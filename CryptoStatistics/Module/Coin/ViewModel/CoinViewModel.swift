//
//  CoinViewModel.swift
//  CryptoStatistics
//
//  Created by Dmitry Apenko on 16.07.2024.
//

import Foundation

//MARK: - ICoinViewModel

protocol ICoinViewModel {
    var coin: CoinConvertedModel? { get }
    var didUpdateCoin: ((CoinConvertedModel?) -> Void)? { get set }
    var switchViewState: ((_ state: CurrentState) -> Void)? { get set }
    func fetchCoin()
}

//MARK: - CoinViewModel

final class CoinViewModel: ICoinViewModel {

    // MARK: Constants

    private enum Constants {
        static let outputDateFormat = "dd.MM.yyyy hh:mm a"
    }

    // MARK: Internal properties

    var coin: CoinConvertedModel?
    var didUpdateCoin: ((CoinConvertedModel?) -> Void)?
    var switchViewState: ((_ state: CurrentState) -> Void)?

    // MARK: Private properties

    private let networkService: INetworkService?
    private let modelConversationService: IModelConversionService?

    private let concurrentQueue = DispatchQueue(label: "queue", attributes: .concurrent)

    // MARK: Initialization

    var coinName: String
    init(
        networkService: INetworkService?,
        modelConversationService: IModelConversionService?,
        coinName: String
    ) {
        self.networkService = networkService
        self.modelConversationService = modelConversationService
        self.coinName = coinName
    }
}

//MARK: - Internal methods
extension CoinViewModel {

    func fetchCoin() {
        switchViewState?(.loading)
        networkService?.getData(with: Endpoint.coin(coinName).url) { [weak self] (result: Result<CoinResponse, NetworkError>) in
            guard let self = self else { return }
            switch result {
            case .success(let result):
                let convertedModel = convertToLocaleModel(result)
                if let convertedModel = convertedModel {
                    concurrentQueue.async(flags: .barrier) {
                        self.coin = convertedModel
                        self.didUpdateCoin?(self.coin)
                    }
                }
            case .failure(let error):
                print(error)
            }
            switchViewState?(.loaded)
        }
    }
}

//MARK: - Private methods
private extension CoinViewModel {

    func convertToLocaleModel(_ coinResponse: CoinResponse) -> CoinConvertedModel? {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.outputDateFormat
        let dateString = dateFormatter.string(from: date)
        let localModel = modelConversationService?.convertServerCoinModelToApp(coinResponse, date: dateString)
        return localModel
    }
}
