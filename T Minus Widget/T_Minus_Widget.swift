//
//  T_Minus_Widget.swift
//  T Minus Widget
//
//  Created by Dylan Hawley on 10/16/23.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
}

struct T_Minus_WidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    @ViewBuilder
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("5")
                    .font(.title)
                    .bold()
                Text("DAYS")
                Spacer()
            }
            .padding(.bottom, 2)
            Text("Nov 14, 4:49PM")
                .font(.caption)
                .padding(.bottom, 8)
            Spacer()
            Text("Crew-1")
                .font(.headline)
        }
        .padding()
        .foregroundColor(.white)
        .background(.black)
    }
}

struct T_Minus_Widget: Widget {
    let kind: String = "T_Minus_Widget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            T_Minus_WidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
//        .contentMarginsDisabled()
//        .supportedFamilies([.systemSmall])
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

#Preview(as: .systemSmall) {
    T_Minus_Widget()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley)
    SimpleEntry(date: .now, configuration: .starEyes)
}
