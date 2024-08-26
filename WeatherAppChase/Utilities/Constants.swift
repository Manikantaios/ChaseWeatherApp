//
//  Constants.swift
//  WeatherAppChase
//

import Foundation

struct Constants {
    static let locationDeniedMssg = "Location permissions are denied. Please enable location services in settings."
    static let shareLocationMssg = "Please Share your location to fetch your current location Weather"
    static let apiKey = "7eb073775018aa85cc958bfa0afe842c"
    static let weatherRequestURL = "https://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f&appid=\(Constants.apiKey)&units=imperial"
    static let weatherQueryURL = "https://api.openweathermap.org/data/2.5/weather?q=%@&appid=\(Constants.apiKey)&units=imperial"
    static let geoCoordinatesURL = "https://api.openweathermap.org/geo/1.0/direct?q=%@&limit=1&appid=\(Constants.apiKey)"
    static let geoCoordinatesForZipURL = "https://api.openweathermap.org/geo/1.0/zip?zip=%@&appid=\(Constants.apiKey)"
    static let iconURL = "https://openweathermap.org/img/wn/%@@2x.png"
    static let networkError = "Unable to fetch Weather. Please retry with different city."
}
