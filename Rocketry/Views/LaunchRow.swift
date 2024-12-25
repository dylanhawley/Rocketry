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

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Text(launch.mission.removingParenthesizedText())
                        .font(.system(size: 18, weight: .semibold))
                        .shadow(color: .black.opacity(0.9), radius: 4)
                    Spacer()
                    if launch.isGoodViewingConditions() {
                        Image(systemName: "eye.fill")
                            .foregroundStyle(.green)
                            .imageScale(.small)
                    }
                }
                Group {
                    Text(launch.location.localityAndAdministrativeArea)
                    Text(launch.launch_service_provider)
                    Spacer()
                    FormattedDateView(date: launch.net)
                }
                .font(.system(size: 14, weight: .medium))
                .opacity(0.8)
            }
            Spacer()
            if launch.vehicle == "Falcon 9" {
                Image("falcon9")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 120, alignment: .top)
                    .clipped()
                    .padding(.top, 20)
            }
        }
        .padding()
        .frame(height: 120)
        .background(WeatherAnimationView(launch: launch))
        .cornerRadius(15)
    }
}

struct FormattedDateView: View {
    let date: Date

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d"
        return formatter
    }()

    private static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mma z"
        formatter.amSymbol = "am"
        formatter.pmSymbol = "pm"
        return formatter
    }()

    var body: some View {
        HStack {
            Text(Self.dateFormatter.string(from: date))
            Spacer()
            Text(Self.timeFormatter.string(from: date))
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
