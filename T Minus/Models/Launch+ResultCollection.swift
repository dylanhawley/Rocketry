//
//  Launch+ResultCollection.swift
//  T Minus
//
//  Created by Dylan Hawley on 7/11/24.
//

import SwiftData
import OSLog


extension Launch {
    convenience init(from result: LaunchResultCollection.Result) {
        self.init(
            code: result.id,
            net: result.net,
            vehicle: result.rocket.configuration.name,
            mission: result.mission.name,
            details: result.mission.description,
            orbit: result.mission.orbit.abbrev,
            pad: result.pad.name,
            country_code: result.pad.country_code,
            longitude: Double(result.pad.longitude) ?? 0,
            latitude: Double(result.pad.latitude) ?? 0
        )
    }
}


extension LaunchResultCollection {
    fileprivate static let logger = Logger(subsystem: "com.example.apple-samplecode.DataCache", category: "parsing")

    /// Loads new launches and deletes outdated ones.
    @MainActor
    static func refresh(modelContext: ModelContext) async {
        do {
            // Fetch the latest set of launches from the server.
            logger.debug("Refreshing the data store...")
            let resultCollection = try await fetchResults()
            logger.debug("Loaded result collection:\n\(resultCollection)")

            // Add the content to the data store.
            for result in resultCollection.results {
                let launch = Launch(from: result)

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
