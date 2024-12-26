//
//  MissionDetailsView.swift
//  Rocketry
//
//  Created by Dylan Hawley on 12/2/24.
//

import SwiftUI

struct MissionDetailsView: View {
    let launch: Launch
    @State private var isExpanded: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if launch.isGoodViewingConditions() {
                GoodToWatchView()
                Divider()
            }
            HStack {
                if let status = launch.status {
                    Text(status.abbrev)
                    .padding(5)
                    .background(status.displayColor.opacity(0.1))
                    .cornerRadius(5)
                    .foregroundStyle(status.displayColor)
                }
                Label {
                    Text(launch.vehicle)
                } icon: {
                    Image("rocket")
                }
                .padding(5)
                .background(Color(.tertiarySystemFill))
                .cornerRadius(5)
                .labelStyle(CustomLabel(spacing: 4))
                Label {
                    Text(launch.orbit)
                } icon: {
                    Image(systemName: "globe.americas")
                }
                .padding(5)
                .background(Color(.tertiarySystemFill))
                .cornerRadius(5)
                .labelStyle(CustomLabel(spacing: 4))
            }
            Text(launch.details)
            .lineLimit(isExpanded ? nil : 3)
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.15)) {
                    isExpanded.toggle()
                }
            }
        }
        .font(Font.system(size: 16))
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
}

//#Preview {
//    MissionDetailsView()
//}
