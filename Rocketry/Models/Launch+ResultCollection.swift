//
//  Launch+ResultCollection.swift
//  Rocketry
//
//  Created by Dylan Hawley on 7/11/24.
//

import SwiftData
import OSLog
import WeatherKit
import CoreLocation

extension Launch {
    convenience init(from result: LaunchResultCollection.Result) {
        self.init(
            code: result.id,
            status: result.status.abbrev,
            last_updated: result.last_updated,
            net: result.net,
            window_start: result.window_start,
            window_end: result.window_end,
            net_precision: result.net_precision.abbrev,
            vehicle: result.rocket.configuration.name,
            mission: result.mission.name,
            details: result.mission.description,
            orbit: result.mission.orbit.abbrev,
            pad: result.pad.name,
            country_code: result.pad.country_code,
            longitude: Double(result.pad.longitude) ?? 0,
            latitude: Double(result.pad.latitude) ?? 0,
            timezone_name: result.pad.location.timezone_name
        )
    }
}

extension LaunchResultCollection {
    fileprivate static let logger = Logger(subsystem: "com.dhawley.Rocketry", category: "parsing")

    /// Loads new launches and deletes outdated ones.
    @MainActor
    static func refresh(modelContext: ModelContext) async {
        do {
            // Fetch the latest set of launches from the server.
            logger.debug("Refreshing the data store...")
            let resultCollection = try await fetchResults()
            logger.debug("Loaded result collection:\n\(resultCollection)")

            let weatherService = WeatherService.shared

            // Add the content to the data store.
            for result in resultCollection.results {
                let launch = Launch(from: result)

                let location = CLLocation(latitude: launch.location.latitude, longitude: launch.location.longitude)
                let oneHourAfterLaunch = launch.net.addingTimeInterval(3600)
                let weatherFilter: WeatherQuery = .hourly(startDate: launch.net, endDate: oneHourAfterLaunch)
                if let weather = try? await weatherService.weather(for: location, including: weatherFilter).first {
                    launch.weather = WeatherModel(hourWeather: weather)
                }

                logger.debug("Inserting \(launch)")
                modelContext.insert(launch)
                try? modelContext.save()
            }

            logger.debug("Refresh complete.")

        } catch let error {
            logger.error("\(error.localizedDescription)")
        }
    }
}
