//
//  LaunchResultCollection.swift
//  T Minus
//
//  Created by Dylan Hawley on 10/30/23.
//

import Foundation


struct LaunchResultCollection: Decodable {
    let results: [Result]
    
    struct Result: Decodable {
        let id: String
        let net: Date
        let rocket: Rocket
        let mission: Mission
        let pad: Pad
        let image: String
        
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
        image: \(image)
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
        let url = URL(string: "https://lldev.thespacedevs.com/2.2.0/launch/upcoming/")!

        let session = URLSession.shared
        guard let (data, response) = try? await session.data(from: url),
              let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200
        else {
            throw DownloadError.missingData
        }

        do {
            let jsonDecoder = JSONDecoder()
            jsonDecoder.dateDecodingStrategy = .iso8601
            return try jsonDecoder.decode(LaunchResultCollection.self, from: data)
        } catch {
            throw DownloadError.wrongDataFormat(error: error)
        }
    }
}


enum DownloadError: Error {
    case wrongDataFormat(error: Error)
    case missingData
}
