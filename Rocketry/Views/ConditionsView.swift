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
        HStack{
            VStack(alignment: .leading, spacing: 10) {
                Label {
                    Text("Cloud Cover".uppercased())
                } icon: {
                    Image(systemName: "cloud.fill")
                }
                .font(Font.system(size: 12))
                .foregroundStyle(.secondary)
                .fontWeight(.semibold)
                .labelStyle(CustomLabel(spacing: 4))
                Text("\(Int(weather.cloudCover * 100))%")
                    .font(.title)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
            
            VStack(alignment: .leading, spacing: 10) {
                Label {
                    Text("Precipitation".uppercased())
                } icon: {
                    Image(systemName: "drop.fill")
                }
                .font(Font.system(size: 12))
                .foregroundStyle(.secondary)
                .fontWeight(.semibold)
                .labelStyle(CustomLabel(spacing: 4))
                Text("\(Int(weather.precipitationChance * 100))%")
                    .font(.title)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
        }
    }
}
