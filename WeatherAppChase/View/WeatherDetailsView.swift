//
//  WeatherDetailsView.swift
//  WeatherAppChase
//

import SwiftUI


struct WeatherDetailsView: View {
    var weatherApiResponse: WeatherDataModel
    
    @State private var isSheetExpanded: Bool = false
    @State private var offset: CGFloat = UIScreen.main.bounds.height * 0.6
    @GestureState private var dragOffset: CGFloat = 0

    var body: some View {
            VStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(weatherApiResponse.name)
                        .bold()
                        .font(.title)
                    HStack {
                        let now = Date()
                        // Convert the timezone offset from the API response to a string (e.g., -18000)
                        let offsetInSeconds = weatherApiResponse.timezone
                        let localTimeString = now.localTimeString(fromOffset: offsetInSeconds)
                        Text("Today, \(localTimeString)")
                            .fontWeight(.light)
                        Spacer()
                        Text("Feels Like \((weatherApiResponse.main.feelsLike.formattedAsInteger() + "°"))")
                            .fontWeight(.light)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                
                VStack {
                    HStack {
                        VStack {
                            IconView(iconCode: weatherApiResponse.weather[0].icon)

                            Text("\(weatherApiResponse.weather[0].main)")
                                .offset(y: -20)
                        }
                        .frame(width: 135, alignment: .leading)
                        
                        Spacer()
                        
                        Text(weatherApiResponse.main.temp.formattedAsInteger() + "°")
                            .font(.system(size: 75))
                            .fontWeight(.bold)
                            .padding()
                            .frame(alignment: .trailing)
                    }
                    
                    Spacer()
                        .frame(height: 10)
                    
                    WeatherDetailsSheet(weatherApiResponse: weatherApiResponse)
                    
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding(16.0)
            .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(hue: 0.656, saturation: 0.787, brightness: 0.354))
        .preferredColorScheme(.dark)
    }
}




struct WeatherDetailsSheet: View {
    var weatherApiResponse: WeatherDataModel

    var body: some View {
            VStack(alignment: .listRowSeparatorLeading, spacing: 10) {
                ScrollView(showsIndicators: true) {

                VStack(alignment: .leading) {
                    
                    Text("Temperature Variations")
                        .fontWeight(.semibold)
                    // Row 1: Min Temp, Max Temp
                    HStack {
                        WeatherAdditionalView(
                            primaryLogo: "thermometer",
                            secondaryLogo: nil,
                            name: "Min Temp",
                            value: "\(weatherApiResponse.main.tempMin.formattedAsInteger())°"
                        )
                        Spacer()
                        WeatherAdditionalView(
                            primaryLogo: "thermometer",
                            secondaryLogo: nil,
                            name: "Max Temp",
                            value: "\(weatherApiResponse.main.tempMax.formattedAsInteger())°"
                        )
                    }
                    
                    Text("Winds")
                        .fontWeight(.semibold)
                    // Row 2: Wind Speed, Wind Temp (if available), Wind Gust (if available)
                    HStack {
                        WeatherAdditionalView(
                            primaryLogo: "wind",
                            secondaryLogo: nil,
                            name: "Speed",
                            value: "\(weatherApiResponse.wind.speed.formattedAsInteger()) m/s"
                        )
                        Spacer()
                        // Wind Temp placeholder, assuming it might be represented by a different image
                        WeatherAdditionalView(
                            primaryLogo: "thermometer",
                            secondaryLogo: nil,
                            name: "Temp",
                            value: "\(weatherApiResponse.main.temp.formattedAsInteger())°"
                        )
                    }
                    if let gust = weatherApiResponse.wind.gust {
                        VStack{
                            WeatherAdditionalView(
                                primaryLogo: "wind",
                                secondaryLogo: "arrow.right.circle",
                                name: "Gust",
                                value: "\(gust.formattedAsInteger()) m/s"
                            )
                        }
                    }
                    
                    
                    VStack(alignment: .leading) {
                        // Row 3: Sunrise, Sunset
                        Text("Sunrise & Sunset")
                            .fontWeight(.semibold)
                        HStack {
                            WeatherAdditionalView(
                                primaryLogo: "sunrise",
                                secondaryLogo: nil,
                                name: "Sunrise",
                                value: Date.fromUnixTimestamp(weatherApiResponse.sys.sunrise).formattedTime()
                            )
                            Spacer()
                            WeatherAdditionalView(
                                primaryLogo: "sunset",
                                secondaryLogo: nil,
                                name: "Sunset",
                                value: Date.fromUnixTimestamp(weatherApiResponse.sys.sunset).formattedTime()
                            )
                        }}
                    
                    Text("Atmosphere")
                        .fontWeight(.semibold)
                    // Row 4: Pressure, Humidity
                    HStack {
                        WeatherAdditionalView(
                            primaryLogo: "gauge",
                            secondaryLogo: nil,
                            name: "Pressure",
                            value: "\(weatherApiResponse.main.pressure) hPa"
                        )
                        Spacer()
                        WeatherAdditionalView(
                            primaryLogo: "humidity",
                            secondaryLogo: nil,
                            name: "Humidity",
                            value: "\(weatherApiResponse.main.humidity)%"
                        )
                    }
                }
                .padding(5.0)
            }
            .background(Color.white)
            .cornerRadius(10)
            .foregroundColor(Color(hue: 0.656, saturation: 0.787, brightness: 0.354))
        }
    }
}
