//
//  CoinsListTableViewCellModel.swift
//  CryptoStatistics
//
//  Created by Dmitry Apenko on 03.07.2024.
//

import Foundation

struct CoinsListTableViewCellModel {
    let coinName: String
    let currentPrice: Double
    let dayDynamicPercents: Double
    let date: String
//
//    init(from coinsListResponse: CoinsListResponse, with date: String) {
//        self.coinName = coinsListResponse.data?.name ?? ""
//        self.currentPrice = getConvertedPrice(coinsListResponse.data?.currentPrice.USDValue ?? 0)
//        self.dayDynamicPercents = getConvertedPercents(coinsListResponse.data?.currentPrice.dayValue.openPrice ?? 0, coinsListResponse.data?.currentPrice.dayValue.closePrice ?? 0)
//        self.date = date
//    }
}

//private extension CoinsListTableViewCellModel {
//
//    func getConvertedPercents(_ value1: Double, _ value2: Double) -> Double {
//        let temp = (value1 - value2) / value1
//        return (temp * 10).rounded() / 10
//    }
//
//    func getConvertedPrice(_ price: Double) -> Double {
//        return (price * 1000).rounded() / 1000
//
//    }
//}
