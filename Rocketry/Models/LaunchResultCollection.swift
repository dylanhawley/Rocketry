//
//  LaunchResultCollection.swift
//  Rocketry
//
//  Created by Dylan Hawley on 10/30/23.
//

import Foundation

struct LaunchResultCollection: Decodable {
    let results: [Result]

    struct Result: Decodable {
        let id: String
        let url: String
        let status: Status
        let last_updated: Date
        let net: Date
        let window_start: Date
        let window_end: Date
        let net_precision: NetPrecision
        let rocket: Rocket
        let mission: Mission
        let pad: Pad
        let image: String?
        
        struct Status: Decodable {
            let name: String
            let abbrev: String
        }
        
        struct NetPrecision: Decodable {
            let name: String
            let abbrev: String
            let description: String
        }

        struct Rocket: Decodable {
            let configuration: RocketConfiguration

            struct RocketConfiguration: Decodable {
                let name: String
            }
        }

        struct Mission: Decodable {
            let name: String
            let description: String
            let orbit: Orbit

            struct Orbit: Decodable {
                let abbrev: String
            }
        }

        struct Pad: Decodable {
            let name: String
            let latitude: String
            let longitude: String
            let country_code: String
            let location: PadLocation

            struct PadLocation: Decodable {
                let timezone_name: String
            }
        }
    }
}

extension LaunchResultCollection.Result: CustomStringConvertible {
    var description: String {
    """
    result: {
        id: \(id),
        net: \(net),
        rocket: {
            configuration: {
                name: \(rocket.configuration.name)
            }
        },
        mission: {
            name: \(mission.name),
            description: \(mission.description),
            orbit: {
                abbrev: \(mission.orbit.abbrev)
            }
        },
        pad: {
            name: \(pad.name),
            latitude: \(pad.latitude),
            longitude: \(pad.longitude),
            country_code: \(pad.country_code)
        },
        image: \(image ?? "null")
    }
    """
    }
}

extension LaunchResultCollection: CustomStringConvertible {
    var description: String {
        var description = "Empty feature collection."
        if let result = results.first {
            description = result.description
            if results.count > 1 {
                description += "\n...and \(results.count - 1) more."
            }
        }
        return description
    }
}

// Fetch new data.
extension LaunchResultCollection {
    /// Gets and decodes the latest launch data from the server.
    static func fetchResults() async throws -> LaunchResultCollection {
        let url = URL(string: "https://ll.thespacedevs.com/2.2.0/launch/upcoming/")!
        let session = URLSession.shared
        let (data, response) = try await session.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw DownloadError.invalidResponse
        }

        guard httpResponse.statusCode == 200 else {
            throw DownloadError.serverError(statusCode: httpResponse.statusCode)
        }

        do {
            let jsonDecoder = JSONDecoder()
            jsonDecoder.dateDecodingStrategy = .iso8601
            return try jsonDecoder.decode(LaunchResultCollection.self, from: data)
        } catch let decodingError as DecodingError {
            throw DownloadError.decodingError(error: decodingError)
        } catch {
            throw DownloadError.wrongDataFormat(error: error)
        }
    }
}

enum DownloadError: Error, LocalizedError {
    case wrongDataFormat(error: Error)
    case decodingError(error: DecodingError)
    case invalidResponse
    case serverError(statusCode: Int)
    case missingData

    var errorDescription: String? {
        switch self {
        case .wrongDataFormat(let error):
            return "Data format error: \(error.localizedDescription)"
        case .decodingError(let error):
            switch error {
            case .keyNotFound(let key, let context):
                return "Could not find key '\(key.stringValue)' in JSON: \(context.debugDescription)"
            case .valueNotFound(let type, let context):
                return "Could not find value of type '\(type)' in JSON: \(context.debugDescription)"
            case .typeMismatch(let type, let context):
                return "Type '\(type)' mismatch: \(context.debugDescription)"
            case .dataCorrupted(let context):
                return "Data corrupted: \(context.debugDescription)"
            @unknown default:
                return "Unknown decoding error: \(error.localizedDescription)"
            }
        case .invalidResponse:
            return "Invalid response from server"
        case .serverError(let statusCode):
            return "Server error with status code: \(statusCode)"
        case .missingData:
            return "Missing data in response"
        }
    }
}
