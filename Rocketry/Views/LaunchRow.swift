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
    @StateObject private var viewModel: WeatherViewModel
        
    init(launch: Launch) {
        self.launch = launch
        _viewModel = StateObject(wrappedValue: WeatherViewModel(weather: launch.weather))
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(launch.mission.removingParenthesizedText())
                    .font(.system(size: 18, weight: .semibold))
                    .shadow(color: .black.opacity(0.7), radius: 2)
                Spacer()
                if viewModel.isGoodViewingConditions {
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
            .opacity(0.8)
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
//            Text(Self.timeFormatter(for: timeZone).string(from: date))
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
