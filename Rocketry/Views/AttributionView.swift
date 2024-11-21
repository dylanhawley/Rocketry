//
//  AttributionView.swift
//  Rocketry
//
//  Created by Dylan Hawley on 11/14/24.
//

import SwiftUI
import WeatherKit

struct AttributionView: View {
    let weatherManager = WeatherManager.shared
    @State private var attribution: WeatherAttribution?
    
    var body: some View {
        VStack {
            if let attribution {
                AsyncImage(url: attribution.combinedMarkDarkURL) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(height: 14)
                } placeholder: {
                    ProgressView()
                }
                
                Text("Forecast data provided by ") + Text("[\(attribution.serviceName)](\(attribution.legalPageURL))")
                    .underline()
                HStack {
                    Spacer()
                    Text("The data has been modified for visual effects")
                    Spacer()
                }
            }
        }
        .font(.footnote)
        .foregroundStyle(.secondary)
        .task {
            Task.detached { @MainActor in
                attribution = await weatherManager.weatherAttribution()
            }
        }
    }
}

#Preview {
    AttributionView()
        .preferredColorScheme(.dark)
}
