//
//  PadMapView.swift
//  Rocketry
//
//  Created by Dylan Hawley on 11/15/24.
//

import SwiftUI
import MapKit

struct PadMapView: View {
    let location: Location
    let visibility: Double?
    @State private var position: MapCameraPosition = .automatic

    var body: some View {
        VStack(alignment: .leading) {
            Label("Visibility".uppercased(), systemImage: "eye.fill")
            .font(Font.system(size: 12))
            .foregroundStyle(.secondary)
            .fontWeight(.semibold)
            .labelStyle(CustomLabel(spacing: 4))
            
            Map(position: $position, interactionModes: []) {
                Marker(location.name, image: "rocket", coordinate: location.coordinate)
                if let visibility = visibility {
                    MapCircle(center: location.coordinate, radius: visibility)
                        .foregroundStyle(.mint.opacity(0.5))
                        .mapOverlayLevel(level: .aboveRoads)

                    let endCoordinate = location.coordinate.destination(distance: visibility, bearing: 90)
                    MapPolyline(coordinates: [location.coordinate, endCoordinate])
                        .stroke(.mint, lineWidth: 2)
                        .mapOverlayLevel(level: .aboveRoads)
                    
                    Annotation("", coordinate: endCoordinate) {
                        Text(formatDistance(visibility))
                            .font(.caption)
                            .padding(4)
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 4))
                    }
                }
            }
            .cornerRadius(10)
            .mapStyle(.hybrid)
            .frame(height: 400)
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }

    private func formatDistance(_ meters: Double) -> String {
        let measurementInMeters = Measurement(value: meters, unit: UnitLength.meters)
        let formatter = MeasurementFormatter()
        formatter.unitOptions = .providedUnit
        formatter.numberFormatter.maximumFractionDigits = 0

        let targetUnit: UnitLength = {
            switch Locale.current.measurementSystem {
            case .us, .uk:
                return .miles
            default:
                return .kilometers
            }
        }()

        return formatter.string(from: measurementInMeters.converted(to: targetUnit))
    }
}

extension CLLocationCoordinate2D {
    func destination(distance: Double, bearing: Double) -> CLLocationCoordinate2D {
        let distanceRadians = distance / 6371000.0 // Earth's radius in meters
        let bearingRadians = bearing * .pi / 180
        let lat1 = latitude * .pi / 180
        let lon1 = longitude * .pi / 180
        
        let lat2 = asin(sin(lat1) * cos(distanceRadians) + 
                       cos(lat1) * sin(distanceRadians) * cos(bearingRadians))
        let lon2 = lon1 + atan2(sin(bearingRadians) * sin(distanceRadians) * cos(lat1),
                               cos(distanceRadians) - sin(lat1) * sin(lat2))
        
        return CLLocationCoordinate2D(latitude: lat2 * 180 / .pi,
                                    longitude: lon2 * 180 / .pi)
    }
}

#if DEBUG
#Preview {
    ModelContainerPreview(PreviewSampleData.inMemoryContainer) {
        PadMapView(location: Launch.sampleLaunches[2].location, visibility: 10)
    }
}
#endif
