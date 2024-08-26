//
//  BannerView.swift
//  WeatherAppChase
//

import SwiftUI
import CoreLocationUI

struct BannerView: View {
    @EnvironmentObject var viewModel: WeatherViewModel
    
    var body: some View {
        VStack {
            Text("Weather App")
                .bold().font(.title)
            Text("Code Challenge")
                .bold().font(.subheadline)
            
            if viewModel.loading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .frame(width: 50, height: 50)
            } else if viewModel.location == nil {
                if viewModel.permissionsDenied {
                    Text(Constants.locationDeniedMssg)
                        .padding(10.0)
                        .bold().font(.body)
                        .multilineTextAlignment(.center)
                } else {
                    Text(Constants.shareLocationMssg)
                        .padding(10.0)
                        .bold().font(.body)
                        .multilineTextAlignment(.center)
                    LocationButton(.shareCurrentLocation) {
                        viewModel.checkLocationAuthorizationStatus()
                    }
                    .cornerRadius(20.0)
                    .symbolVariant(.slash)
                    .foregroundColor(.black)
                    .padding(10.0)
                }
                
                if viewModel.networkError {
                    Text(Constants.networkError)
                        .padding(10.0)
                        .bold().font(.body)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)

                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            // Always attempt to fetch location on appear
            if !viewModel.locationFetchError {
                viewModel.checkLocationAuthorizationStatus()
            }
        }
    }
}



#Preview {
    BannerView()
}
