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
            VStack(spacing: 16) {
                VStack(alignment: .leading) {
                    Text(launch.mission.removingParenthesizedText())
                        .font(.largeTitle)
                        .bold()
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                    FormattedDateView(date: launch.net)
//                        .font(.title3)
                }
                
                // Launch details
                VStack(alignment: .leading) {
                    if launch.isGoodViewingConditions() {
                        GoodToWatchView()
                    }
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
                    Text("Last updated: \(launch.last_updated.formatted())")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .padding(.top, 16)
                        .frame(maxWidth: .infinity, alignment: .center)
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

struct CustomLabel: LabelStyle {
    var spacing: Double = 0.0
    
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: spacing) {
            configuration.icon
            configuration.title
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
