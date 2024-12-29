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
    @StateObject private var viewModel: WeatherViewModel
        
    init(launch: Launch) {
        self.launch = launch
        _viewModel = StateObject(wrappedValue: WeatherViewModel(weather: launch.weather ))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if viewModel.isGoodViewingConditions {
                GoodToWatchView()
                Divider()
            }
            HStack {
                if let status = launch.status {
                    Label {
                        Text(status.abbrev)
                    } icon: {
                        if UIImage(systemName: status.iconName) != nil {
                            Image(systemName: status.iconName)
                        } else {
                            Image(status.iconName)
                        }
                    }
                    .padding(5)
                    .background(status.displayColor.opacity(0.1))
                    .cornerRadius(5)
                    .foregroundStyle(status.displayColor)
                    .labelStyle(CustomLabel(spacing: 4))
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
