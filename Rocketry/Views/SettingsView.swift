//
//  SettingsView.swift
//  Rocketry
//
//  Created by Dylan Hawley on 12/26/24.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            Form {
                Section {
                    NavigationLink(destination: SubscriptionView()) {
                        Label("Appearance", systemImage: "square.filled.on.square")
                    }
                }
                
                Section {
                    NavigationLink(destination: GoodToWatchSettingsView()) {
                        Label("Good to Watch Conditions", systemImage: "eye.fill")
                    }
                }
                
                Section(header: Text("Information")) {
                    NavigationLink(destination: SubscriptionView()) {
                        Label("Help", systemImage: "questionmark.circle")
                    }
                    NavigationLink(destination: SubscriptionView()) {
                        Label("About", systemImage: "info.circle")
                    }
                }
                
                Section(header: Text("Support our costs")) {
                    NavigationLink(destination: SubscriptionView()) {
                        Label("Subscription", systemImage: "star.fill")
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct SubscriptionView: View {
    var body: some View {
        Text("Subscription View")
            .navigationTitle("Subscription")
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct GoodToWatchSettingsView: View {
    @AppStorage("cloudCoverFilterEnabledKey") private var cloudCoverFilterEnabled: Bool = true
    @AppStorage("maxCloudCoverKey") private var maxCloudCover: Double = 25
    
    @AppStorage("visibilityFilterEnabledKey") private var visibilityFilterEnabled: Bool = true
    @AppStorage("minVisibilityKey") private var minVisibility: Double = 13
    
    @AppStorage("precipitationFilterEnabledKey") private var precipitationFilterEnabled: Bool = true
    @AppStorage("maxPrecipitationChanceKey") private var maxPrecipitationChance: Double = 5
    
    // Define default values
    private let defaultCloudCoverFilterEnabled = true
    private let defaultMaxCloudCover = 25.0
    
    private let defaultVisibilityFilterEnabled = true
    private let defaultMinVisibility = 13.0
    
    private let defaultPrecipitationFilterEnabled = true
    private let defaultMaxPrecipitationChance = 5.0
    
    var body: some View {
        Form {
            Section() {
                Toggle("Maximum Cloud Cover", isOn: $cloudCoverFilterEnabled)
                
                if cloudCoverFilterEnabled {
                    HStack {
                        Slider(value: $maxCloudCover, in: 0...100, step: 1) {
                            Text("Max Cloud Cover")
                        }
                        Text("\(Int(maxCloudCover))%")
                            .frame(width: 50, alignment: .trailing)
                    }
                }
            }
            
            Section() {
                Toggle("Minimum Visibility", isOn: $visibilityFilterEnabled)
                
                if visibilityFilterEnabled {
                    HStack {
                        Slider(value: $minVisibility, in: 0...25, step: 1) {
                            Text("Min Visibility (miles)")
                        }
                        Text("\(Int(minVisibility)) mi")
                            .frame(width: 50, alignment: .trailing)
                    }
                }
            }
            
            Section() {
                Toggle("Maximum Precipitation Chance", isOn: $precipitationFilterEnabled)
                
                if precipitationFilterEnabled {
                    HStack {
                        Slider(value: $maxPrecipitationChance, in: 0...100, step: 1) {
                            Text("Max Precipitation Chance")
                        }
                        Text("\(Int(maxPrecipitationChance))%")
                            .frame(width: 50, alignment: .trailing)
                    }
                }
            }
            
            // --- Reset to Default Values ---
            Section {
                Button(action: {
                    resetToDefaults()
                }) {
                    Text("Reset to Defaults")
                }
                .tint(.blue)
            }
        }
        .navigationTitle("Good To Watch Conditions")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func resetToDefaults() {
        cloudCoverFilterEnabled = defaultCloudCoverFilterEnabled
        maxCloudCover = defaultMaxCloudCover
        
        visibilityFilterEnabled = defaultVisibilityFilterEnabled
        minVisibility = defaultMinVisibility
        
        precipitationFilterEnabled = defaultPrecipitationFilterEnabled
        maxPrecipitationChance = defaultMaxPrecipitationChance
    }
}


#Preview {
    SettingsView()
}
