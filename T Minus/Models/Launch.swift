//
//  Launch.swift
//  T Minus
//
//  Created by Dylan Hawley on 7/4/24.
//

import SwiftUI
import SwiftData

@Model
class Launch {
    /// A unique identifier associated with each launch.
    @Attribute(.unique) var code: String

    var net: Date
    var vehicle: String
    var mission: String
    var details: String
    var orbit: String
    var pad: String
    var location: Location

    /// Creates a new launch from the specified values.
    init(
        code: String,
        net: Date,
        vehicle: String,
        mission: String,
        details: String,
        orbit: String,
        pad: String,
        longitude: Double,
        latitude: Double
    ) {
        self.code = code
        self.net = net
        self.vehicle = vehicle
        self.mission = mission
        self.details = details
        self.orbit = orbit
        self.pad = pad
        self.location = Location(name: pad, longitude: longitude, latitude: latitude)
    }
}

/// A convenience for accessing a launch in an array by its identifier.
extension Array where Element: Launch {
    // Gets the first launch in the array with the specified ID, if any.
    subscript(id: Launch.ID?) -> Launch? {
        first { $0.id == id }
    }
}

// A string represenation of the launch.
extension Launch: CustomStringConvertible {
    var description: String {
        "\(mission) \(vehicle) \(pad)"
    }
}

extension Launch {
    /// A filter that checks for a date and text in the launch's location name.
    static func predicate(
        searchText: String
//        searchDate: Date
    ) -> Predicate<Launch> {
//        let calendar = Calendar.autoupdatingCurrent
//        let start = calendar.startOfDay(for: searchDate)
//        let end = calendar.date(byAdding: .init(day: 1), to: start) ?? start

        return #Predicate<Launch> { launch in
            (searchText.isEmpty || launch.vehicle.contains(searchText) || launch.details.contains(searchText) || launch.mission.contains(searchText))
//            &&
//            (launch.net > start && launch.net < end)
        }
    }

    /// Report the range of dates over which there are launches.
    static func dateRange(modelContext: ModelContext) -> ClosedRange<Date> {
        let descriptor = FetchDescriptor<Launch>(sortBy: [.init(\.net, order: .forward)])
        guard let launches = try? modelContext.fetch(descriptor),
              let first = launches.first?.net,
              let last = launches.last?.net else { return .distantPast ... .distantFuture }
        return first ... last
    }

    /// Reports the total number of launches.
    static func totalLaunches(modelContext: ModelContext) -> Int {
        (try? modelContext.fetchCount(FetchDescriptor<Launch>())) ?? 0
    }
}

/// Ensure that the model's conformance to Identifiable is public.
extension Launch: Identifiable {}
