//
//  WeatherViewModel.swift
//  WeatherAppChase
//

import Foundation
import CoreLocation
import UIKit
import Combine
import SwiftUI

class WeatherViewModel: NSObject, CLLocationManagerDelegate, ObservableObject {
    private let viewModel = CLLocationManager()
    
    @Published var location: CLLocationCoordinate2D?
    @Published var loading = false
    @Published var permissionsDenied = false
    @Published var networkError = false
    var locationFetchError = false
    @Published var weatherData: WeatherDataModel?
    private let dataManager: WeatherDataManaging
    @AppStorage("lastLatitude") private var lastLatitude: Double?
    @AppStorage("lastLongitude") private var lastLongitude: Double?
    
    init(_ dataManager: WeatherDataManaging) {
        self.dataManager = dataManager
        super.init()
        viewModel.delegate = self
        viewModel.desiredAccuracy = kCLLocationAccuracyBest
        checkLocationAuthorizationStatus()
    }
    
    func checkLocationAuthorizationStatus() {
        let status = viewModel.authorizationStatus
        switch status {
        case .notDetermined:
            viewModel.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            fetchLocation()
            permissionsDenied = false
        case .denied, .restricted:
            permissionsDenied = true
        default:
            permissionsDenied = true
        }
    }
    
    private func fetchLocation() {
        locationFetchError = false
        loading = true
        viewModel.requestLocation()
    }

    func checkForLocation() {
        fetchLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.first?.coordinate {
            DispatchQueue.main.async {
                if self.locationHasChanged(newLocation: currentLocation) {
                    self.location = currentLocation
                    self.updateStoredLocation(currentLocation)
                    self.fetchWeather(for: currentLocation)
                } else {
                    self.location = currentLocation
                }
                self.loading = false
            }
        }
    }
    
    private func locationHasChanged(newLocation: CLLocationCoordinate2D) -> Bool {
        guard let lastLat = lastLatitude, let lastLong = lastLongitude else {
            return true
        }
        return lastLat != newLocation.latitude || lastLong != newLocation.longitude
    }
    
    private func updateStoredLocation(_ location: CLLocationCoordinate2D) {
        lastLatitude = location.latitude
        lastLongitude = location.longitude
    }
    
    @MainActor
    func fetchWeather(for location: CLLocationCoordinate2D) {
        Task {
            do {
                self.networkError = false
                let fetchedWeatherData = try await self.dataManager.fetchWeather(using: .coordinates(latitude: location.latitude, longitude: location.longitude))
                DispatchQueue.main.async {
                    self.weatherData = fetchedWeatherData
                }
            } catch {
                self.weatherData = nil
                self.networkError = true
                print("Failed to fetch weather: \(error)")
            }
        }
    }
    
    @MainActor
    func fetchWeather(with query: WeatherQuery) async throws  {
        do {
            self.networkError = false
            let response = try await self.dataManager.fetchWeather(using: query)
            DispatchQueue.main.async {
                self.weatherData = response
            }
        } catch {
            self.weatherData = nil
            self.networkError = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to fetch location:", error)
        DispatchQueue.main.async {
            self.locationFetchError = true
            self.loading = false
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorizationStatus()
    }
}
