//
//  ExchangeRatesService.swift
//  CurrencyExchange
//
//  Created by Justin Fogarty on 5/15/23.
//

import Foundation


class ExchangeRateService {
    func getExchangeRates(baseCurrency: String, completion: @escaping (Result<ExchangeRateResponse, Error>) -> Void) {
        
        let url = URL(string:"https://api.apilayer.com/fixer/latest?symbols=USD,EUR,GBP,JPY,AUD,CAD,CHF,CNY,SEK,NZD&base=" + baseCurrency)
        
        var request = URLRequest(url: url!)
        
        request.addValue("fxtiGMj1TocISCLgj44xVsCz9CkxHHt9", forHTTPHeaderField: "apikey")
        
        request.httpMethod = "GET"
        
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data returned", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let exchangeRates = try decoder.decode(ExchangeRateResponse.self, from: data)
                completion(.success(exchangeRates))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func getExchangeRatesWithDates(baseCurrency: String, currencyOne: String, currencyTwo: String, completion: @escaping (Result<ExchangeRateWithDatesResponse, Error>) -> Void) {
        
        // Setting our time interval as todays date and the date 5 days ago while also formatting the dates to the conform to the api params
        
        let today = Date()
        
        let fiveDaysAgo = Calendar.current.date(byAdding: .day, value: -5, to: today)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let endDate = dateFormatter.string(from: today)
        
        let startDate = dateFormatter.string(from: fiveDaysAgo!)
        
        let url = URL(string:"https://api.apilayer.com/fixer/timeseries?start_date=" + startDate + "&end_date=" + endDate + "&symbols=" + currencyOne + "," + currencyTwo + "&base=" + baseCurrency)
        
        var request = URLRequest(url: url!)
        
        request.addValue("fxtiGMj1TocISCLgj44xVsCz9CkxHHt9", forHTTPHeaderField: "apikey")
        
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data returned", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let exchangeRates = try decoder.decode(ExchangeRateWithDatesResponse.self, from: data)
                completion(.success(exchangeRates))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
        
}
    
    

