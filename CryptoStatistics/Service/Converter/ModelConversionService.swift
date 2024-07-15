//
//  ModelConversionService.swift
//  CryptoStatistics
//
//  Created by Dmitry Apenko on 05.07.2024.
//

import Foundation

//MARK: - ModelConversionService
final class ModelConversionService {

    func convertServerModelToApp(_ coinsListResponse: CoinsListResponse, date: String) -> CoinsListTableViewCellModel {

        let localModel = CoinsListTableViewCellModel(
            coinName: coinsListResponse.data.name,
            currentPrice: getConvertedPrice(coinsListResponse.data.currentPrice.USDValue),
            dayDynamicPercents: getConvertedPercents(coinsListResponse.data.currentPrice.dayValue.closePrice, coinsListResponse.data.currentPrice.dayValue.openPrice),
            date: date
        )
        return localModel
    }
}

//MARK: - Private methods
private extension ModelConversionService {

    func getConvertedPercents(_ value1: Double, _ value2: Double) -> Double {
        let temp = (value1 - value2) / value1
        return (temp * 1000).rounded() / 1000
    }

    func getConvertedPrice(_ price: Double) -> Double {
        return (price * 1000).rounded() / 1000

    }
}
