//
//  ExchangeRatesResponse.swift
//  CurrencyExchange
//
//  Created by Justin Fogarty on 5/15/23.
//

import Foundation


struct ExchangeRateResponse: Codable {
    let base: String
    let date: String
    let rates: [String: Double]
    let success: Bool
    let timestamp: Int
}






