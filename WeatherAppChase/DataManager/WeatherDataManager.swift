//
//  WeatherDataManager.swift
//  WeatherAppChase
//

import Foundation
import Combine
import CoreLocation

// Enum to represent the different query types
enum WeatherQuery {
    case coordinates(latitude: CLLocationDegrees, longitude: CLLocationDegrees)
    case location(cityName: String, stateCode: String?, countryCode: String?)
}

enum WeatherFetchError: Error {
    case unableToFetch
}

protocol WeatherDataManaging {
    func fetchWeather(using query: WeatherQuery) async throws -> WeatherDataModel
    func fetchCoordinates(for cityName: String, stateCode: String?, countryCode: String?) async throws -> [GeocodingResponse]
    func fetchCoordinatesForZip(zip: String, countryCode: String) async throws -> ZipCodeResponse
}

class WeatherDataManager: ObservableObject, WeatherDataManaging {
    private var cancellable: AnyCancellable?
    
  
    func fetchWeather(using query: WeatherQuery) async throws -> WeatherDataModel {
        let urlString: String
        
        switch query {
        case .coordinates(let latitude, let longitude):
            urlString = String(format: Constants.weatherRequestURL, latitude, longitude)
            
        case .location(let cityName, let stateCode, let countryCode):
            // Check if cityName is numeric (indicating a ZIP code)
            if cityName.allSatisfy(\.isNumber) {
                // Use cityName as ZIP code
                let zipCode = cityName
                let coordinatesResponse = try await fetchCoordinatesForZip(zip: zipCode, countryCode: countryCode ?? "US")
                let latitude = coordinatesResponse.lat
                let longitude = coordinatesResponse.lon
                urlString = String(format: Constants.weatherRequestURL, latitude, longitude)
            } else {
                // Treat as city name
                var locationQuery = cityName
                if let state = stateCode {
                    locationQuery += ",\(state)"
                }
                if let country = countryCode {
                    locationQuery += ",\(country)"
                }
                urlString =  String(format:Constants.weatherQueryURL, locationQuery)
            }
        }
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        guard let (data, _) = try? await URLSession.shared.data(from: url),
              let responseBody = try? JSONDecoder().decode(WeatherDataModel.self, from: data) else {
            throw WeatherFetchError.unableToFetch
        }
        
        return responseBody
    }

    // Function to fetch coordinates using city name, state, and country
    func fetchCoordinates(for cityName: String, stateCode: String? = nil, countryCode: String? = nil) async throws -> [GeocodingResponse] {
        var query = "\(cityName)"
        if let state = stateCode {
            query += ",\(state)"
        }
        if let country = countryCode {
            query += ",\(country)"
        }
        
        let urlString = String(format: Constants.geoCoordinatesURL, query)
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        guard let (data, _) = try? await URLSession.shared.data(from: url),
                let response = try? JSONDecoder().decode([GeocodingResponse].self, from: data) else {
            throw WeatherFetchError.unableToFetch
        }
        
        return response
    }

    
    // Function to fetch coordinates by zip code
    func fetchCoordinatesForZip(zip: String, countryCode: String) async throws -> ZipCodeResponse {
       
        let urlString = String(format: Constants.geoCoordinatesForZipURL, "\(zip),\(countryCode)")
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        guard let (data, _) = try? await URLSession.shared.data(from: url),
              let zipCodeResponse = try? JSONDecoder().decode(ZipCodeResponse.self, from: data) else {
            throw WeatherFetchError.unableToFetch
        }
        
        return zipCodeResponse
    }

    deinit {
        cancellable?.cancel() // Ensure to cancel any running subscriptions
    }
}
