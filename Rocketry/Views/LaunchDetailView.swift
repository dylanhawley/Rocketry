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
    @State private var detailedLaunch: LaunchDetailed? = nil
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
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
                    if let detailedLaunch = detailedLaunch {
                        let vidURLs = detailedLaunch.vidURLs
                        if !vidURLs.isEmpty {
                            let highestPriorityVideo = vidURLs.max(by: { $0.priority < $1.priority })
                            LivestreamView(source: highestPriorityVideo!)
                        }
                    }
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
        .onAppear {
            Task { await fetchVideoURL() }
        }
    }

    private func fetchVideoURL() async {
        do {
            let source = URL(string: launch.url)!
            let (data, _) = try await URLSession.shared.data(from: source)
            let decoded = try JSONDecoder().decode(LaunchDetailed.self, from: data)
            await MainActor.run {
                self.detailedLaunch = decoded
            }
        } catch {
            print("Failed to fetch or decode detailed launch data: \(error)")
        }
    }
}

#if DEBUG
#Preview {
    ModelContainerPreview(PreviewSampleData.inMemoryContainer) {
        LaunchDetailView(launch: Launch.sampleLaunches[2])
    }
}
#endif
