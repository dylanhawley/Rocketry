//
//  PadMapView.swift
//  T Minus
//
//  Created by Dylan Hawley on 11/15/24.
//

import SwiftUI
import MapKit

struct PadMapView: View {
    let location: Location
    @State private var position: MapCameraPosition = .automatic

    var body: some View {
        VStack(alignment: .leading) {
            (Text(Image(systemName: "mappin.and.ellipse")) + Text(" Launch Pad".uppercased()))
                .font(Font.system(size: 12))
                .fontWeight(.medium)
                .shadow(radius: 1)

            Map(position: $position, interactionModes: []) {
                Marker(location.name, coordinate: location.coordinate)
                    .tint(.red)
            }
            .scrollDisabled(true)
            .cornerRadius(10)
            .mapStyle(.hybrid)
            .mapControlVisibility(.hidden)
            .frame(height: 400)
            .onTapGesture {
                let mapItem = MKMapItem(
                    placemark: .init(
                        coordinate: location.coordinate
                    )
                )
                mapItem.name = location.name
                mapItem.pointOfInterestCategory = .airport
                mapItem.openInMaps()
            }
            .onAppear {
                position = .region(MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.4, longitudeDelta: 0.4)))
            }
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
}

#if DEBUG
#Preview {
    ModelContainerPreview(PreviewSampleData.inMemoryContainer) {
        PadMapView(location: Launch.sampleLaunches[2].location)
    }
}
#endif
