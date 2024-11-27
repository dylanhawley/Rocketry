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
            (Text(Image(systemName: "mappin.and.ellipse")) + Text(" ") + Text("Visibility".uppercased()))
                .font(Font.system(size: 12))
                .fontWeight(.medium)
            
            Map(position: $position, interactionModes: []) {
                Marker(location.name, image: "rocket", coordinate: location.coordinate)
                visibility.map {
                    MapCircle(center: location.coordinate, radius: $0)
                        .foregroundStyle(.mint.opacity(0.5))
                        .mapOverlayLevel(level: .aboveRoads)
                }
            }
            .cornerRadius(10)
            .mapStyle(.hybrid)
            .frame(height: 400)
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
}

#if DEBUG
#Preview {
    ModelContainerPreview(PreviewSampleData.inMemoryContainer) {
        PadMapView(location: Launch.sampleLaunches[2].location, visibility: 10)
    }
}
#endif
