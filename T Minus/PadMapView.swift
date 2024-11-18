//
//  PadMapView.swift
//  T Minus
//
//  Created by Dylan Hawley on 11/15/24.
//

import SwiftUI
import MapKit

struct PadMapView: View {
    let location: CLLocationCoordinate2D
    let name: String
    @State private var position: MapCameraPosition = .automatic

    var body: some View {
        VStack(alignment: .leading) {
            (Text(Image(systemName: "mappin.and.ellipse")) + Text(" Launch Pad".uppercased()))
                .font(Font.system(size: 12))
                .fontWeight(.medium)
                .shadow(radius: 1)

            Map(position: $position) {
                Marker(name, coordinate: location)
                    .tint(.red)
            }
            .cornerRadius(10)
            .mapStyle(.hybrid)
            .mapControlVisibility(.hidden)
            .frame(height: 400)
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
        .onAppear {
            position = .region(MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)))
        }
    }
}

#Preview {
    PadMapView(location: CLLocationCoordinate2D(latitude: 34.632, longitude: -120.611), name: "39A")
}
