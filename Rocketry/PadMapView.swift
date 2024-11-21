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
    @State private var position: MapCameraPosition = .automatic
    @State private var isInteractionEnabled: Bool = false

    var body: some View {
        VStack(alignment: .leading) {
            (Text(Image(systemName: "mappin.and.ellipse")) + Text(" Launch Pad".uppercased()))
                .font(Font.system(size: 12))
                .fontWeight(.medium)
            
            Button {
                let mapItem = MKMapItem(
                    placemark: .init(
                        coordinate: location.coordinate
                    )
                )
                mapItem.name = location.name
                mapItem.pointOfInterestCategory = .airport
                mapItem.openInMaps()
            } label: {
                Map(position: $position, interactionModes: []) {
                    Marker(location.name, coordinate: location.coordinate)
                        .tint(.red)
                }
                .cornerRadius(10)
                .mapStyle(.hybrid)
                .frame(height: 400)
                .onAppear {
                    position = .region(MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.4, longitudeDelta: 0.4)))
                }
            }
            .disabled(!isInteractionEnabled)
        }
        .onAppear {
            let animationDuration = 0.3
            DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
                isInteractionEnabled = true
            }
        }
        .onDisappear {
            isInteractionEnabled = false
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
