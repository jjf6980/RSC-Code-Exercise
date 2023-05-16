//
//  ExchangeRateViewModel.swift
//  CurrencyExchange
//
//  Created by Justin Fogarty on 5/15/23.
//

import Foundation


class ExchangeRateViewModel: ObservableObject {
    @Published var currencyRates: [String:Double] = [:]
    
    @Published var showAlert = false
    
    @Published var isLoading = false
    
    private let exchangeRateService = ExchangeRateService()
    
    
    func fetchExchangeRates(selectedCurrency:String) {
        self.isLoading = true
        exchangeRateService.getExchangeRates(baseCurrency: selectedCurrency) { [weak self] result in
            switch result {
            case .success(let exchangeRateResponse):
                let currencyRates = exchangeRateResponse.rates.filter { $0.key != selectedCurrency }
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


