//
//  CoinService.swift
//  CryptoStatistics
//
//  Created by Vadim Chistiakov on 31.07.2024.
//

import Combine

final class CoinService {
    
    private let networkService: INetworkService
    
    init(networkService: INetworkService) {
        self.networkService = networkService
    }
    
    func getCoin(_ endpoint: Endpoint) -> AnyPublisher<CoinResponse, NetworkError> {
        networkService.getData(with: endpoint.url)
    }
    
}
