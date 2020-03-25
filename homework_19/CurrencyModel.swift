//
//  CurrencyModel.swift
//  homework_19
//
//  Created by Александра Лесничая on 3/25/20.
//  Copyright © 2020 Alexandra Lesnichaya. All rights reserved.
//

import Foundation

struct CurrencyInfo {
    let name: String
    let rate: Double
}

struct CurrencyModel: Decodable {
    let rates: RatesModel
    let date: String
}

struct RatesModel: Decodable {
    let BYN: Double
    let RUB: Double
    let USD: Double
}

