//
//  Rocketry_WidgetTimer.swift
//  Rocketry Widget
//
//  Created by Dylan Hawley on 12/12/24.
//

import WidgetKit
import SwiftUI
import SwiftData

struct Rocketry_Widget2EntryView: View {
    var entry: Provider.Entry
    
    @ViewBuilder
    var body: some View {
        if let launch = entry.launch {
            VStack(alignment: .leading) {
                Text(launch.mission).bold()
                (Text("in ") + Text(launch.net, style: .relative))
            }
            .padding()
            .foregroundColor(.white)
        } else {
            Text("Unable to Load")
                .foregroundColor(.gray)
        }
    }
}

struct Rocketry_Widget2: Widget {
    let kind: String = "Rocketry Widget Live"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            Rocketry_Widget2EntryView(entry: entry)
                .containerBackground(for: .widget) {
                    Color.black
//                    if let launch = entry.launch {
//                        SkyView(date: launch.net, location: launch.location.coordinate, timezone_name: launch.timezone_name)
//                    } else {
//                        Color.black
//                    }
                }
        }
        .contentMarginsDisabled()
        .supportedFamilies([.systemSmall])
        .configurationDisplayName("Upcoming Launch Live")
        .description("Keep track of the next space launch.")
    }
}

#Preview(as: .systemSmall) {
    Rocketry_Widget2()
} timeline: {
    SimpleEntry(date: .now, launch: Launch.sampleLaunches.last!)
}
