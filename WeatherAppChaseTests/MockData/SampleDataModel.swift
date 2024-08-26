//
//  SampleDataModel.swift
//  WeatherAppChase
//

import Foundation
@testable import WeatherAppChase

func load<T: Decodable>(_ filename: String) -> T {
    let bundle = Bundle(for: WeatherViewModelTests.self)
    guard let file =  bundle.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
    }

    do {
        let data = try Data(contentsOf: file)
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}
