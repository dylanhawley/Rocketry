//
//  Launch.swift
//  Rocketry
//
//  Created by Dylan Hawley on 7/4/24.
//

import SwiftUI
import SwiftData

@Model
class Launch {
    /// A unique identifier associated with each launch.
    @Attribute(.unique) var code: String

    var url: String
    var status: MissionStatus?
    var last_updated: Date
    var net: Date
    var window_start: Date
    var window_end: Date
    var net_precision: NetPrecision?
    var vehicle: String
    var mission: String
    var details: String
    var orbit: String
    var pad: String
    var country_code: String
    var location: Location
    var timezone_name: String
    var weather: WeatherModel?

    /// Creates a new launch from the specified values.
    init(
        code: String,
        url: String,
        status: String,
        last_updated: Date,
        net: Date,
        window_start: Date,
        window_end: Date,
        net_precision: String,
        vehicle: String,
        mission: String,
        details: String,
        orbit: String,
        pad: String,
        country_code: String,
        longitude: Double,
        latitude: Double,
        timezone_name: String,
        weather: WeatherModel? = nil
    ) {
        self.code = code
        self.url = url
        self.status = MissionStatus(rawValue: status)
        self.last_updated = last_updated
        self.net = net
        self.window_start = window_start
        self.window_end = window_end
        self.net_precision = NetPrecision(rawValue: net_precision)
        self.vehicle = vehicle
        self.mission = mission
        self.details = details
        self.orbit = orbit
        self.pad = pad
        self.country_code = country_code
        self.location = Location(name: pad, longitude: longitude, latitude: latitude)
        self.timezone_name = timezone_name
        self.weather = weather
    }
}

/// Represents the status of a launch.
enum MissionStatus: String, Codable {
    case tbd = "TBD"
    case tbc = "TBC"
    case go = "Go"
    case success = "Success"
    case inFlight = "In Flight"

    /// Provides a human-readable description of the status.
    var description: String {
        switch self {
        case .tbd: return "To Be Determined"
        case .tbc: return "To Be Confirmed"
        case .go: return "Go for Launch"
        case .success: return "Launch Successful"
        case .inFlight: return "Launch In Flight"
        }
    }
}

/// Represents the precision of a launch's net (No Earlier Than) time.
enum NetPrecision: String, Codable {
    case minute = "MIN"
    case second = "SEC"
    case hour = "HR"
    case day = "DAY"
    case month = "M"

    /// Provides a human-readable description of the precision.
    var description: String {
        switch self {
        case .minute: return "Minute"
        case .second: return "Second"
        case .hour: return "Hour"
        case .day: return "Day"
        case .month: return "Month"
        }
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
        "\(code) \(mission) \(vehicle) \(pad)"
    }
}

extension Launch {
    /// A filter that checks for text in the launch's location name.
    static func predicate(
        searchText: String,
        onlyFutureLaunches: Bool = false,
        onlyPastLaunches: Bool = false,
        onlyUSLaunches: Bool = true,
        startDate: Date? = nil,
        endDate: Date? = nil
    ) -> Predicate<Launch> {
        let currentDate = Date()
        
        return #Predicate<Launch> { launch in
            (searchText.isEmpty || launch.vehicle.localizedStandardContains(searchText) ||
             launch.details.localizedStandardContains(searchText) ||
             launch.mission.localizedStandardContains(searchText)) &&
            (!onlyFutureLaunches || launch.net > currentDate) &&
            (!onlyPastLaunches || launch.net < currentDate) &&
            (!onlyUSLaunches || launch.country_code == "USA") &&
            (startDate == nil || launch.net >= startDate!) &&
            (endDate == nil || launch.net <= endDate!)
        }
    }
}

/// Ensure that the model's conformance to Identifiable is public.
extension Launch: Identifiable {}
