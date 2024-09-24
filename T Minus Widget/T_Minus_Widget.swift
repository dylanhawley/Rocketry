//
//  T_Minus_Widget.swift
//  T Minus Widget
//
//  Created by Dylan Hawley on 10/16/23.
//

import WidgetKit
import SwiftUI
import SwiftData

struct Provider: AppIntentTimelineProvider {
    @MainActor func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), launches: getLaunches(), configuration: ConfigurationAppIntent())
    }

    @MainActor func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), launches: getLaunches(), configuration: configuration)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        let entries: [SimpleEntry] = await [SimpleEntry(date: .now, launches: getLaunches(), configuration: configuration)]

        return Timeline(entries: entries, policy: .after(.now.advanced(by: 60)))
    }
    
    @MainActor
    private func getLaunches() -> [Launch] {
        guard let modelContainer = try? ModelContainer(for: Launch.self) else {
            return []
        }
        let descriptor = FetchDescriptor<Launch>()
        let launches = try? modelContainer.mainContext.fetch(descriptor)
        
        return launches ?? []
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let launches: [Launch]
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
            Text(formatDate(entry.launches.first!.net))
                .font(.caption)
                .padding(.bottom, 8)
            Spacer()
            Text(entry.launches.first!.mission)
                .font(.headline)
        }
        .padding()
        .foregroundColor(.white)
        .background(.black)
    }
    
    private func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, h:mm a" // Format: Nov 14, 4:49 PM
        return dateFormatter.string(from: date)
    }
}

struct T_Minus_Widget: Widget {
    let kind: String = "T_Minus_Widget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            T_Minus_WidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .contentMarginsDisabled()
        .supportedFamilies([.systemSmall])
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
    SimpleEntry(date: .now, launches: Launch.sampleLaunches, configuration: .smiley)
//    SimpleEntry(date: .now, configuration: .starEyes)
}
