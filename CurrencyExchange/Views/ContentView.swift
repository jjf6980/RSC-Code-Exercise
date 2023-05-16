//
//  ContentView.swift
//  CurrencyExchange
//
//  Created by Justin Fogarty on 5/15/23.
//

import SwiftUI
import Combine


struct ContentView: View {
    
    @StateObject private var viewModel = ExchangeRateViewModel()
        
    @State private var selectedItems: [String] = []
    
    @State private var shouldNavigate = false
    
    @State private var currencyOne = ""
    
    @State private var currencyTwo = ""
    
    @State private var textInput: String = ""
    @State private var selectedOption: String = "EUR"
    
    let options = ["USD", "EUR", "JPY", "GBP", "AUD", "CAD", "CHF", "CNY", "SEK", "NZD"]
    
    var body: some View {
        NavigationView{
            VStack{
                
                HStack {
                    // setting up our picker and populating it with currencies
                    Picker("", selection: $selectedOption) {
                        ForEach(options, id: \.self) { option in
                            Text(option)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding()
                    
                    // Setting up the input field and ensuring only numbers can be added no matter the device
                    
                    TextField("Enter Amount Here", text: $textInput)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .onReceive(Just(textInput)) { newValue in
                        let filtered = newValue.filter { "0123456789".contains($0) }
                        if filtered != newValue {
                            self.textInput = filtered
                        }
                    }
                }
                // display a loading view incase the request takes long the response from the endpoint can be slow sometimes
                if viewModel.isLoading {
                    ProgressView()
                }
                
                // populating the rows and allowing them to be selectable
                List(viewModel.currencyRates.sorted(by: <), id: \.key) { currency, rate in
                    let isSelected = selectedItems.contains(currency)
                    Button(action: {
                        if isSelected {
                            selectedItems.removeAll(where: {$0 == currency})
                        }
                        else{
                            selectedItems.append(currency)
                            if selectedItems.count == 2 {
                                
                                currencyOne = (selectedItems.first?.description)!
                                currencyTwo = (selectedItems.last?.description)!
                                
                                shouldNavigate = true
                            }
                        }
                    })
                    {
                    HStack{
                        Text(currency)
                        Spacer()
                        Text("\(rate * (Double(textInput.description) ?? 00.0) , specifier: "%.2f")")
                    }
                    }.listRowBackground(self.selectedItems.contains(currency) ? Color(UIColor.gray) : Color(UIColor.white))
                }.sheet(isPresented: $shouldNavigate, onDismiss: {

                    selectedItems.removeAll()
                    
                }){
                    CurrencyDateView(currencyOne: currencyOne, currencyTwo: currencyTwo, baseCurrency: selectedOption, currencyAmount: textInput)
                }
                
                Button(action: {
                    // populates our viewmodel
                    if(textInput == ""){
                        
                    }
                    
                    viewModel.fetchExchangeRates(selectedCurrency: selectedOption.description)
                    
                }) {
                    Text("Get Conversion")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
                
                // display an alert if the api fails or timesout
            }.alert(isPresented: $viewModel.showAlert){
                Alert(title: Text("API Error"),
                message: Text("Failed to fetch data from the API."),
                dismissButton: .default(Text("OK")))
            }
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

