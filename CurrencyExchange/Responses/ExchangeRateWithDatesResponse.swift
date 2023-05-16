//
//  ExchangeRateWithDatesResponse.swift
//  CurrencyExchange
//
//  Created by Justin Fogarty on 5/16/23.
//

import Foundation

struct ExchangeRateWithDatesResponse: Codable {
    let base: String
    let rates: [String : [String : Double]]
    let success: Bool
}
