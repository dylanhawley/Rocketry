//
//  PreviewSampleData.swift
//  T Minus
//
//  Created by Dylan Hawley on 8/27/24.
//

import SwiftData
import SwiftUI

/// An actor that provides an in-memory model container for previews.
actor PreviewSampleData {
    @MainActor
    static var container: ModelContainer = {
        return try! inMemoryContainer()
    }()

    @MainActor
    static var inMemoryContainer: () throws -> ModelContainer = {
        let schema = Schema([Launch.self])
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: schema, configurations: [configuration])
        let sampleData: [any PersistentModel] = Launch.sampleLaunches
        Task { @MainActor in
            sampleData.forEach {
                container.mainContext.insert($0)
            }
        }
        return container
    }
}

// Sample launches for use in previews
extension Launch {
    @MainActor static let sampleLaunches: [Launch] = [
        .init(
            code: "1",
            net: ISO8601DateFormatter().date(from: "2024-07-03T06:01:00Z") ?? .now,
            vehicle: "Falcon 9 Block 5",
            mission: "Starlink Group 8-9",
            details: "A batch of satellites for the Starlink mega-constellation - SpaceX's project for space-based Internet communication system.",
            orbit: "Low Earth Orbit",
            pad: "Space Launch Complex 40",
            country_code: "USA",
            longitude: -80.57735736,
            latitude: 28.56194122,
            timezone_name: "America/New_York"
        ),
        .init(
            code: "2",
            net: ISO8601DateFormatter().date(from: "2024-07-04T23:00:00Z") ?? .now,
            vehicle: "Long March 6A",
            mission: "Unknown Payload",
            details: "Details TBD.",
            orbit: "Unknown",
            pad: "Launch Complex 9A",
            country_code: "USA",
            longitude: 111.5802,
            latitude: 38.8583,
            timezone_name: "America/New_York"
        ),
        .init(
            code: "3",
            net: ISO8601DateFormatter().date(from: "2024-07-08T21:20:00Z") ?? .now,
            vehicle: "Falcon 9 Block 5",
            mission: "Türksat 6A",
            details: "Türksat 6A is Turkey's first domestically manufactured geostationary communications satellite. It is to reside in 42° East orbital slot, providing services to customers in Turkey, as well as in Europe, Northern coast of Africa, Middle East, India and Indonesia.",
            orbit: "Geostationary Transfer Orbit",
            pad: "Space Launch Complex 40",
            country_code: "USA",
            longitude: -80.57735736,
            latitude: 28.56194122,
            timezone_name: "America/New_York"
        ),
        .init(
            code: "4",
            net: ISO8601DateFormatter().date(from: "2024-07-09T18:00:00Z") ?? .now,
            vehicle: "Ariane 62",
            mission: "Maiden Flight",
            details: "Maiden Flight of the Ariane 62 launcher from Korou.",
            orbit: "Unknown",
            pad: "Ariane Launch Area 4",
            country_code: "?",
            longitude: -52.786838,
            latitude: 5.256319,
            timezone_name: ""
        ),
        .init(
            code: "5",
            net: ISO8601DateFormatter().date(from: "2024-07-15T00:00:00Z") ?? .now,
            vehicle: "Falcon 9 Block 5",
            mission: "WorldView Legion 3 & 4",
            details: "WorldView Legion is a constellation of Earth observation satellites built and operated by Maxar. Constellation is planned to consist of 6 satellites in both polar and mid-inclination orbits, providing 30 cm-class resolution.",
            orbit: "Sun-Synchronous Orbit",
            pad: "Space Launch Complex 4E",
            country_code: "USA",
            longitude: -120.611,
            latitude: 34.632,
            timezone_name: ""
        ),
        .init(
            code: "6",
            net: ISO8601DateFormatter().date(from: "2024-07-31T00:00:00Z") ?? .now,
            vehicle: "Atlas V 551",
            mission: "USSF-51",
            details: "Classified payload for the US Space Force.",
            orbit: "Unknown",
            pad: "Space Launch Complex 41",
            country_code: "USA",
            longitude: -80.58303644,
            latitude: 28.58341025,
            timezone_name: "America/New_York"
        ),
        .init(
            code: "7",
            net: ISO8601DateFormatter().date(from: "2024-07-31T00:00:00Z") ?? .now,
            vehicle: "Ceres-1S",
            mission: "Unknown Payload",
            details: "Details TBD.",
            orbit: "Unknown",
            pad: "Haiyang Spaceport",
            country_code: "?",
            longitude: 121.235103,
            latitude: 36.676794,
            timezone_name: ""
        ),
        .init(
            code: "8",
            net: ISO8601DateFormatter().date(from: "2024-07-31T00:00:00Z") ?? .now,
            vehicle: "Electron",
            mission: "Capella Acadia 3",
            details: "Payload consists of a single SAR Earth-imaging Acadia satellite, a new generation satellite designed, manufactured, and operated by Capella Space.",
            orbit: "Low Earth Orbit",
            pad: "Unknown Pad",
            country_code: "USA",
            longitude: 177.865826,
            latitude: -39.260881,
            timezone_name: ""
        )
    ]
}

extension ViewModel {
    static var preview: ViewModel {
        let model = ViewModel()
        model.totalLaunches = 8
        return model
    }
}
