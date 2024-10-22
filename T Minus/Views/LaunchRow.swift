//
//  LaunchRow.swift
//  T Minus
//
//  Created by Dylan Hawley on 8/27/24.
//

import SwiftUI


struct LaunchRow: View {
    var launch: Launch

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(launch.mission)
                .font(.headline)
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
            Text(launch.details)
                .font(.system(size: 16, weight: .light))
                .lineLimit(3)
            FormattedDateView(date: launch.net)
                .font(.system(size: 16, weight: .light))
                .opacity(0.8)
        }
        .foregroundStyle(.white)
        .padding()
        .background(
            ZStack {
                SkyView(date: launch.net, location: launch.location.coordinate)
//                CloudsView(thickness: Cloud.Thickness.allCases.randomElement() ?? .regular,
//                           topTint: cloudTopStops.interpolated(amount: timeIntervalFromDate(launch.net)),
//                           bottomTint: cloudBottomStops.interpolated(amount: timeIntervalFromDate(launch.net)))
            }
        )
        .cornerRadius(15)
    }
}

struct FormattedDateView: View {
    let date: Date

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
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
