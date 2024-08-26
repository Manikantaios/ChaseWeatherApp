//
//  MockDataManager.swift
//  WeatherAppChaseTests
//

import Foundation
@testable import WeatherAppChase

class MockDataManager: WeatherDataManaging {

    func fetchWeather(using query: WeatherQuery) async throws -> WeatherDataModel {
        return load("SampleData.json") as WeatherDataModel
    }
    
    func fetchCoordinates(for cityName: String, stateCode: String?, countryCode: String?) async throws -> [GeocodingResponse] {
        return [GeocodingResponse(name: "The Colony", localNames: nil, lat: 33.0247, lon: 96.9263, country: "US", state: "Texas")]
    }
    
    func fetchCoordinatesForZip(zip: String, countryCode: String) async throws -> ZipCodeResponse {
        return ZipCodeResponse(zip: "75010", name: "The Colony", lat: 33.0247, lon: 96.9263, country: "US")
    }
}
