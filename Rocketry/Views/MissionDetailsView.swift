//
//  MissionDetailsView.swift
//  Rocketry
//
//  Created by Dylan Hawley on 12/2/24.
//

import SwiftUI

struct MissionDetailsView: View {
    let launch: Launch
    @State private var isExpanded: Bool = false
    
    @AppStorage("cloudCoverFilterEnabledKey") private var cloudCoverFilterEnabled: Bool = true
    @AppStorage("maxCloudCoverKey") private var maxCloudCover: Double = 25
    @AppStorage("visibilityFilterEnabledKey") private var visibilityFilterEnabled: Bool = true
    @AppStorage("minVisibilityKey") private var minVisibility: Double = 13
    @AppStorage("precipitationFilterEnabledKey") private var precipitationFilterEnabled: Bool = true
    @AppStorage("maxPrecipitationChanceKey") private var maxPrecipitationChance: Double = 5
    var isGoodViewingConditions: Bool {
        guard let weather = launch.weather else { return false }
        if cloudCoverFilterEnabled, weather.cloudCover > (maxCloudCover / 100.0) { return false }
        if visibilityFilterEnabled, weather.visibility < minVisibility { return false }
        if precipitationFilterEnabled, weather.precipitationChance > (maxPrecipitationChance / 100.0) { return false }
        return true
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if isGoodViewingConditions {
                GoodToWatchView()
                Divider()
            }
            HStack {
                if let status = launch.status {
                    Label {
                        Text(status.abbrev)
                    } icon: {
                        if UIImage(systemName: status.iconName) != nil {
                            Image(systemName: status.iconName)
                        } else {
                            Image(status.iconName)
                        }
                    }
                    .padding(5)
                    .background(status.displayColor.opacity(0.1))
                    .cornerRadius(5)
                    .foregroundStyle(status.displayColor)
                    .labelStyle(CustomLabel(spacing: 4))
                }
                Label {
                    Text(launch.vehicle)
                } icon: {
                    Image("rocket")
                }
                .padding(5)
                .background(Color(.tertiarySystemFill))
                .cornerRadius(5)
                .labelStyle(CustomLabel(spacing: 4))
                Label {
                    Text(launch.orbit)
                } icon: {
                    Image(systemName: "globe.americas")
                }
                .padding(5)
                .background(Color(.tertiarySystemFill))
                .cornerRadius(5)
                .labelStyle(CustomLabel(spacing: 4))
            }
            Text(launch.details)
            .lineLimit(isExpanded ? nil : 3)
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.15)) {
                    isExpanded.toggle()
                }
            }
        }
        .font(Font.system(size: 16))
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
}

//#Preview {
//    MissionDetailsView()
//}
