//
//  AcknowledgementsView.swift
//  Rocketry
//
//  Created by Dylan Hawley on 12/31/24.
//

import SwiftUI
import WeatherKit

struct AcknowledgementsView: View {
    let weatherManager = WeatherManager.shared
    @State private var attribution: WeatherAttribution?
    
    private var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "N/A"
    }
    
    private var buildNumber: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "N/A"
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section() {
                    if let attribution {
                        HStack {
                            AsyncImage(url: attribution.combinedMarkDarkURL) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 14)
                            } placeholder: {
                                ProgressView()
                            }
                            Spacer()
                            Link("Other Data Sources", destination: attribution.legalPageURL)
                        }
                    }
                    Link("Launch Library 2", destination: URL(string: "https://thespacedevs.com/")!)
                    Link("The Space Devs", destination: URL(string: "https://thespacedevs.com/")!)
                    Text("We gather space flight data from Launch Library 2, an open-source initiative maintained by The Space Devs")
                }
                Section {
                    Text("Thank you for supporting Rocketry. We hope you enjoy using this app as much as we enjoyed building it!")
                    .multilineTextAlignment(.leading)
                }
            }
        }
        .navigationTitle("Acknowledgements")
        .task {
            Task.detached { @MainActor in
                attribution = await weatherManager.weatherAttribution()
            }
        }
    }
}

#Preview {
    AcknowledgementsView()
}
