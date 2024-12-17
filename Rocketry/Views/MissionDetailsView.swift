//
//  MissionDetailsView.swift
//  Rocketry
//
//  Created by Dylan Hawley on 12/2/24.
//

import SwiftUI

struct MissionDetailsView: View {
    let launch: Launch
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            (Text(Image(systemName: "globe.americas")) + Text(" ") + Text(launch.orbit))
                .padding(5)
                .background(Color(.tertiarySystemFill))
                .cornerRadius(5)
            Text(launch.details)
                .font(.body)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
}

//#Preview {
//    MissionDetailsView()
//}
