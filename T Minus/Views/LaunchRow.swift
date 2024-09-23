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
                        .background(Color("LaunchLabelColor"))
                        .cornerRadius(5)
                    Text(launch.pad)
                        .padding(5)
                        .background(Color("LaunchLabelColor"))
                        .cornerRadius(5)
                }
            }
            Text(launch.details)
            FormattedDateView(date: launch.net)
        }
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
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "calendar")
                Text(Self.dateFormatter.string(from: date))
            }
            HStack {
                Image(systemName: "clock")
                Text(Self.timeFormatter.string(from: date))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

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
