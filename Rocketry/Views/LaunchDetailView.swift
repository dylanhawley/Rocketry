//
//  LaunchDetailView.swift
//  Rocketry
//
//  Created by Dylan Hawley on 11/7/24.
//

import SwiftUI
import Solar

struct LaunchDetailView: View {
    let launch: Launch
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Header with background
                VStack(alignment: .leading) {
                    Text(launch.mission)
                        .font(.largeTitle)
                        .bold()
                    FormattedDateView(date: launch.net)
                        .font(.title3)
                    ScrollView(.horizontal) {
                        HStack {
                            Text(launch.vehicle)
                                .padding(5)
                                .background(Color(.tertiarySystemFill))
                                .cornerRadius(5)
                            Text(launch.pad)
                                .padding(5)
                                .background(Color(.tertiarySystemFill))
                                .cornerRadius(5)
                        }
                        .font(.system(size: 16, weight: .light))
                    }
                }
                
                // Launch details
                VStack(alignment: .leading, spacing: 24) {
                    MissionDetailsView(launch: launch)
                    URL(string: launch.url).map { LivestreamView(source: $0) }
                    PadMapView(location: launch.location, visibility: launch.weather?.visibility)
                    launch.weather.map { ConditionsView(weather: $0) }
                }
            }
            .padding()
        }
        .scrollIndicators(.hidden)
        .background(
            WeatherAnimationView(launch: launch)
            .ignoresSafeArea()
        )
    }
}

#if DEBUG
#Preview {
    ModelContainerPreview(PreviewSampleData.inMemoryContainer) {
        LaunchDetailView(launch: Launch.sampleLaunches[2])
    }
}
#endif
