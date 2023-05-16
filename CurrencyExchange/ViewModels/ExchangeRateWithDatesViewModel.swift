//
//  ExchangeRateWithDatesViewModel.swift
//  CurrencyExchange
//
//  Created by Justin Fogarty on 5/16/23.
//

import Foundation


class ExchangeRateWithDatesViewModel: ObservableObject {
    
    @Published var currencyRates: [String:[String:Double]] = [:]
    
    @Published var showAlert = false
    
    @Published var isLoading = false
    
    private let exchangeRateService = ExchangeRateService()
    
    
    func fetchExchangeRatesWithDates(selectedCurrency:String, currencyOne: String, currencyTwo: String) {
        self.isLoading = true
        exchangeRateService.getExchangeRatesWithDates(baseCurrency: selectedCurrency, currencyOne: currencyOne, currencyTwo: currencyTwo) { [weak self] result in
            switch result {
            case .success(let exchangeRateWithDatesResponse):
                let currencyRates = exchangeRateWithDatesResponse.rates.filter { $0.key != selectedCurrency }
                DispatchQueue.main.async {
                    self?.currencyRates = currencyRates
                    self?.isLoading = false
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.isLoading = false
                    self?.showAlert = true
                    
                }
                print("Error getting exchange rates: \(error)")
            }
        }
    }
}

