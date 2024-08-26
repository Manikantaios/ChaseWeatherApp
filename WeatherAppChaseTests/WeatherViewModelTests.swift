//
//  WeatherViewModelTests.swift
//  WeatherAppChaseTests
//

import XCTest
import CoreLocation
@testable import WeatherAppChase

final class WeatherViewModelTests: XCTestCase {

    let viewModel: WeatherViewModel = WeatherViewModel(MockDataManager())
   
    @MainActor func testFetchWeather() {
        XCTAssertNil(viewModel.weatherData)
        
        viewModel.fetchWeather(for: CLLocationCoordinate2D(latitude: 32.7668, longitude: -96.7836))
        let exp = expectation(description: "Test after 2 seconds")
        _ = XCTWaiter.wait(for: [exp], timeout: 2.0)
        
        XCTAssertNotNil(viewModel.weatherData)
        XCTAssertEqual(viewModel.weatherData?.coord.lat, 32.7668)
        XCTAssertEqual(viewModel.weatherData?.base, "stations")
    }

}
