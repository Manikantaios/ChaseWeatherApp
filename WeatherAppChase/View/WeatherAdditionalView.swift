//
//  WeatherAdditionalView.swift
//  WeatherAppChase
//

import SwiftUI

struct WeatherAdditionalView: View {
    var primaryLogo: String
    var secondaryLogo: String?
    var name: String
    var value: String

    var body: some View {
        HStack {
            // Primary Image
            Image(systemName: primaryLogo)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .foregroundColor(.black)

            // Secondary Image (optional)
            if let secondaryLogo = secondaryLogo {
                Image(systemName: secondaryLogo)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.gray)
            }

            VStack(alignment: .leading) {
                Text(name)
                    .fontWeight(.light)
                Text(value)
                    .fontWeight(.bold)
            }
            .padding(.leading, 5)

            Spacer()
        }
        .padding()
    }
}


