//
//  LaunchRow.swift
//  Rocketry
//
//  Created by Dylan Hawley on 8/27/24.
//

import SwiftUI
import Solar

struct LaunchRow: View {
    var launch: Launch
    @AppStorage("usePadTimeZone") private var usePadTimeZone: Bool = false
    
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
    
    var shouldUseOverlayBlendMode: Bool {
        guard let weather = launch.weather else { return false }
        return !weather.isDaylight || [.none, .thin].contains(weather.cloudThickness)
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(launch.mission.removingParenthesizedText())
                    .font(.system(size: 18, weight: .semibold))
                    .shadow(color: .black.opacity(0.7), radius: 2)
                Spacer()
                if isGoodViewingConditions {
                    Image(systemName: "eye.fill")
                        .imageScale(.small)
                }
            }
            Group {
                Text(launch.location.localityAndAdministrativeArea)
                Text(launch.launch_service_provider)
                Spacer()
                FormattedDateView(date: launch.net, timeZone: usePadTimeZone
                  ? TimeZone(identifier: launch.timezone_name) ?? .current
                  : .current)
            }
            .font(.system(size: 14, weight: .medium))
            .opacity(shouldUseOverlayBlendMode ? 0.8 : 1)
        }
        .padding()
        .frame(height: 120)
        .background(SmallWeatherAnimationView(launch: launch))
        .cornerRadius(15)
    }
}

struct FormattedDateView: View {
    let date: Date
    let timeZone: TimeZone

    private static func dateFormatter(for timeZone: TimeZone) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d"
        formatter.timeZone = timeZone
        return formatter
    }

    private static func timeFormatter(for timeZone: TimeZone) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("j:mm z")
        formatter.timeZone = timeZone
        return formatter
    }

    var body: some View {
        HStack {
            Text(Self.dateFormatter(for: timeZone).string(from: date))
            Spacer()
            let timeString = Self.timeFormatter(for: timeZone).string(from: date)
            if let amPmRange = timeString.range(of: "AM") ?? timeString.range(of: "PM") {
                let timeWithoutAmPm = timeString[..<amPmRange.lowerBound]
                let amPm = timeString[amPmRange.lowerBound...]

                Text(timeWithoutAmPm) +
                Text(amPm)
                    .font(.system(size: 12))
            } else {
                Text(timeString)
            }
        }
    }
}

#if DEBUG
#Preview {
    ModelContainerPreview(PreviewSampleData.inMemoryContainer) {
        VStack {
            ForEach(Launch.sampleLaunches.prefix(1), id: \.code) { launch in
                LaunchRow(launch: launch)
            }
        }
        .padding()
        .frame(minWidth: 300, alignment: .leading)
    }
}
#endif
