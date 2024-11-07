//
//  T_Minus_Widget.swift
//  T Minus Widget
//
//  Created by Dylan Hawley on 10/16/23.
//

import WidgetKit
import SwiftUI
import SwiftData

struct Provider: TimelineProvider {
    let modelContext = ModelContext(try! ModelContainer(for: Launch.self))
    
    // New function to fetch the launch
    private func fetchLaunch() throws -> Launch? {
        do {
            return try modelContext.fetch(
                FetchDescriptor<Launch>(predicate: Launch.predicate(searchText: "", onlyFutureLaunches: true, onlyUSLaunches: true),
                                        sortBy: [SortDescriptor(\Launch.net, order: .forward)])
            ).first!
        } catch {
            print("Error fetching launch: \(error)")
            return nil
        }
    }
    
    func placeholder(in context: Context) -> SimpleEntry {
        let launch = try! fetchLaunch()
        return SimpleEntry(date: Date(), launch: launch)
    }
    
    func getSnapshot(in context: Context, completion: @escaping @Sendable (SimpleEntry) -> Void) {
        let launch = try! fetchLaunch()
        let entry = SimpleEntry(date: Date(), launch: launch)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping @Sendable (Timeline<SimpleEntry>) -> Void) {
        var entries: [SimpleEntry] = []
        let launch = try! fetchLaunch()
        let entry = SimpleEntry(date: .now, launch: launch)
        entries.append(entry)
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let launch: Launch?
}

struct T_Minus_WidgetEntryView: View {
    var entry: Provider.Entry
    
    @ViewBuilder
    var body: some View {
        if let launch = entry.launch {
            let timeRemaining = calculateTimeRemaining(from: launch.net)
            
            VStack(alignment: .leading) {
                HStack {
                    Text(timeRemaining.number)
                        .font(.title)
                        .bold()
                        .minimumScaleFactor(0.1)
                    Text(timeRemaining.unit)
                        .lineLimit(1)
                        .minimumScaleFactor(0.1)
                    Spacer()
                    if let weather = launch.weather { Image(systemName: weather.symbolName) }
                }
                .padding(.bottom, 2)
                Text(formatDate(launch.net))
                    .font(.caption)
                    .padding(.bottom, 8)
                Spacer()
                Text(launch.mission)
                    .font(.headline)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
            }
            .padding()
            .foregroundColor(.white)
        } else {
            Text("Unable to Load")
                .foregroundColor(.gray)
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, h:mm a" // Format: Nov 14, 4:49 PM
        return dateFormatter.string(from: date)
    }
    
    private func calculateTimeRemaining(from targetDate: Date) -> (number: String, unit: String) {
        let now = Date()
        let remainingTime = targetDate.timeIntervalSince(now)
        
        if remainingTime <= 0 {
            return ("-", "")
        }
        
        let days = Int(remainingTime) / (3600 * 24)
        let hours = (Int(remainingTime) % (3600 * 24)) / 3600
        let minutes = (Int(remainingTime) % 3600) / 60
        
        if days > 0 {
            return ("\(days)", days == 1 ? "DAY" : "DAYS")
        } else if hours > 0 {
            return ("\(hours)", hours == 1 ? "HOUR" : "HOURS")
        } else if minutes > 0 {
            return ("\(minutes)", minutes == 1 ? "MINS" : "MINUTES")
        } else {
            return ("Now", "")
        }
    }
}

struct T_Minus_Widget: Widget {
    let kind: String = "T Minus Widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            T_Minus_WidgetEntryView(entry: entry)
                .containerBackground(for: .widget) {
                    if let launch = entry.launch {
                        SkyView(date: launch.net, location: launch.location.coordinate, timezone_name: launch.timezone_name)
                    } else {
                        Color.black
                    }
                }
        }
        .contentMarginsDisabled()
        .supportedFamilies([.systemSmall])
        .configurationDisplayName("Upcoming Launch")
        .description("Keep track of the next space launch.")
    }
}

#Preview(as: .systemSmall) {
    T_Minus_Widget()
} timeline: {
    SimpleEntry(date: .now, launch: Launch.sampleLaunches.last!)
}
