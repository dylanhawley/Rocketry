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
                .padding(.top, 8)
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
            }
            Text(launch.details)
            Divider()
            FormattedDateView(date: launch.net)
        }
        .padding(12)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
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
        .foregroundStyle(Color(.systemBlue))
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
