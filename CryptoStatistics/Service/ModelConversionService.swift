//
//  ModelConversionService.swift
//  CryptoStatistics
//
//  Created by Dmitry Apenko on 05.07.2024.
//

import Foundation

final class ModelConversionService {

    func convertServerModelToApp(_ coinsListResponse: CoinsListResponse, date: String) -> CoinsListTableViewCellModel? {

        var localModel = CoinsListTableViewCellModel(
            coinName: coinsListResponse.data?.name ?? "",
            currentPrice: getConvertedPrice(coinsListResponse.data?.currentPrice.USDValue ?? 0),
            dayDynamicPercents: getConvertedPercents(coinsListResponse.data?.currentPrice.dayValue.openPrice ?? 0, coinsListResponse.data?.currentPrice.dayValue.closePrice ?? 0),
            date: date
        )
        return localModel
    }
}

private extension ModelConversionService {

    func getConvertedPercents(_ value1: Double, _ value2: Double) -> Double {
        let temp = (value1 - value2) / value1
        return (temp * 10).rounded() / 10
    }

    func getConvertedPrice(_ price: Double) -> Double {
        return (price * 1000).rounded() / 1000

    }
}
