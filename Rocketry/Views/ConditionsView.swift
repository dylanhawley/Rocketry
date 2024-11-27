//
//  ConditionsView.swift
//  Rocketry
//
//  Created by Dylan Hawley on 11/26/24.
//

import SwiftUI

struct ConditionsView: View {
    let weather: WeatherModel
    
    var cloudGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(stops: [
                .init(color: Color.blue, location: 0.0), // Clear/Sunny
                .init(color: Color.blue.opacity(0.8), location: 0.125), // Mostly Clear/Mostly Sunny
                .init(color: Color.gray.opacity(0.6), location: 0.375), // Partly Cloudy/Partly Sunny
                .init(color: Color.gray.opacity(0.8), location: 0.625), // Mostly Cloudy
                .init(color: Color.gray, location: 0.875), // Cloudy
                .init(color: Color.gray, location: 1.0) // Fully overcast
            ]),
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            (Text(Image(systemName: "cloud")) + Text(" ") + Text("Cloud Cover".uppercased()))
                .font(Font.system(size: 12))
                .fontWeight(.medium)
            ProgressView(value: weather.cloudCover)
                .progressViewStyle(
                    RangedProgressView(range: 0...1, foregroundColor: AnyShapeStyle(cloudGradient), backgroundColor: .clear)
                )
                .frame(maxHeight: 5)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
}
