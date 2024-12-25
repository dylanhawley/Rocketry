//
//  Location.swift
//  Rocketry
//
//  Created by Dylan Hawley on 7/10/24.
//

import CoreLocation

/// A location on Earth.
struct Location: Codable {
    /// A string that describes the location.
    var name: String
    
    /// The address of the location
    var locality: String

    /// The longitude of the location, given in degrees between -180 and 180.
    var longitude: Double

    /// The latitude of the location, given in degrees between -90 and 90.
    var latitude: Double

    /// The longitude and latitude collected into a location coordinate.
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    /// A detailed description of the location.
    var details: String
    
    /// The locality, and state or province associated with the location.
    var localityAndAdministrativeArea: String {
        let components = locality.components(separatedBy: ", ")
        guard components.count == 3 else { return locality }
        return "\(components[0]), \(components[1])"
    }
    
    /// The city associated with the location.
    func fetchLocality() async -> String? {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        return await withCheckedContinuation { continuation in
            location.placemark { placemark, _ in
                continuation.resume(returning: placemark?.locality)
            }
        }
    }
    
    /// The state or province associated with the location.
    func fetchAdministrativeArea() async -> String? {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        return await withCheckedContinuation { continuation in
            location.placemark { placemark, _ in
                continuation.resume(returning: placemark?.administrativeArea)
            }
        }
    }
}

extension CLLocation {
    func placemark(completion: @escaping (_ placemark: CLPlacemark?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first, $1) }
    }
}
