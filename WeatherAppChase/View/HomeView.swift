//
//  HomeView.swift
//  WeatherAppChase
//

import SwiftUI
import CoreLocation

struct HomeView: View {
    @StateObject var viewModel = WeatherViewModel(WeatherDataManager()) 
    @State private var searchText = ""
    
    var body: some View {
        VStack(spacing: 20.0) {
           
                SearchToolBarView(
                    searchText: searchText,
                    onSearch: performSearch
                )
                .frame(alignment: .top)
                .background(Color(hue: 0.656, saturation: 0.787, brightness: 0.354))
            
            
            if let weatherData = viewModel.weatherData {
                WeatherDetailsView(weatherApiResponse: weatherData)
            } else {
                if viewModel.loading {
                    LoadingView()
                } else {
                    BannerView()
                        .environmentObject(viewModel)
                }
            }
        }
        .padding(.vertical, 20)
        .background(Color(hue: 0.663, saturation: 0.904, brightness: 0.739))
        .preferredColorScheme(.dark)
        .onAppear {
            if viewModel.location == nil && !viewModel.loading {
                viewModel.checkLocationAuthorizationStatus()
            }
        }
    }
    
    // Function to compare the current location with the last saved location
    
    func performSearch(searchText: String) {
        guard !searchText.isEmpty else {
            print("Search input is empty")
            return
        }

        Task {
            do {
                // Check if the searchText is a ZIP code (numeric only)
                if searchText.allSatisfy(\.isNumber) {
                    try await viewModel.fetchWeather(with: .location(cityName: searchText, stateCode: nil, countryCode: "US"))
                } else {
                    // Treat as a city name query
                    try await viewModel.fetchWeather(with: .location(cityName: searchText, stateCode: nil, countryCode: nil))
                }
                DispatchQueue.main.async {
                    self.searchText = ""
                }
            } catch {
                print("Error fetching weather: \(error)")
                
            }
        }
    }


}

#Preview {
    HomeView()
}


