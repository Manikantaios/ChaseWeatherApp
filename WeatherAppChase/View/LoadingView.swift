//
//  LoadingView.swift
//  WeatherAppChase
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        Image("Splash")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .edgesIgnoringSafeArea(.all)
            .overlay(
                VStack {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .frame(width: 50, height: 50)
                        .padding()
                }
            )
    }
}

#Preview {
    LoadingView()
}
