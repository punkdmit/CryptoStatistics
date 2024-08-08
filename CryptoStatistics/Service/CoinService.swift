//
//  CoinService.swift
//  CryptoStatistics
//
//  Created by Dmitry Apenko on 04.08.2024.
//

import Foundation
import Combine

protocol ICoinService {
    func fetchCoin(_ endpoint: Endpoint) async throws -> CoinResponse
    func fetchCoin(_ endpoint: Endpoint) -> AnyPublisher<CoinResponse, NetworkError>
}

final class CoinService: ICoinService {
    private let networkService: INetworkService

    init(networkService: INetworkService) {
        self.networkService = networkService
    }

    func fetchCoin(_ endpoint: Endpoint) async throws -> CoinResponse {
        do {
            return try await networkService.getData(with: endpoint.url)
        } catch {
            throw error
        }
    }

    func fetchCoin(_ endpoint: Endpoint) -> AnyPublisher<CoinResponse, NetworkError> {
        networkService.getData(with: endpoint.url)
    }
}
