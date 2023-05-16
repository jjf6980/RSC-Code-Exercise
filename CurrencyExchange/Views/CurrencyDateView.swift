//
//  CurrencyDateView.swift
//  CurrencyExchange
//
//  Created by Justin Fogarty on 5/16/23.
//

import SwiftUI

struct CurrencyDateView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    let currencyOne: String
    
    let currencyTwo: String
    
    let baseCurrency: String
    
    let currencyAmount: String
    
    @StateObject private var viewModel = ExchangeRateWithDatesViewModel()
    
    var body: some View {
        VStack{
            // Sets the currency and amount from the previous view
            HStack{
                Text(baseCurrency)
                Text(currencyAmount)
            }
            // create the table and rows sorted by descending from todays date
            List {
                ForEach(viewModel.currencyRates.sorted(by: { $0.key > $1.key }), id: \.key) { date, currency in
                    Section(header: Text(date)) {
                        ForEach(currency.sorted(by: { $0.key < $1.key }), id: \.key) { currency, rate in
                            Text("\(currency): \(rate * (Double(currencyAmount.description) ?? 00.0) , specifier: "%.2f")")
                        }
                    }
                }
            }
            
            Button(action: {
                // dismiss our view
                presentationMode.wrappedValue.dismiss()
                
            }) {
                Text("Back")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
            
        }.onAppear(){
            //Fetch our data 
            viewModel.fetchExchangeRatesWithDates(selectedCurrency: baseCurrency, currencyOne: currencyOne, currencyTwo: currencyTwo)
        }
    }
}

struct CurrencyDateView_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyDateView(currencyOne: "USD", currencyTwo: "JPY", baseCurrency: "EUR", currencyAmount: "100")
    }
}
