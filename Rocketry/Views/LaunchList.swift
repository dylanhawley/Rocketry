//
//  LaunchList.swift
//  Rocketry
//
//  Created by Dylan Hawley on 8/27/24.
//

import SwiftUI
import SwiftData


struct LaunchList: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var futureLaunches: [Launch]
    @Query private var pastLaunches: [Launch]
    @Namespace private var namespace

    init(searchText: String = String()) {
        _futureLaunches = Query(filter: Launch.predicate(searchText: searchText, onlyFutureLaunches: true), sort: \Launch.net, order: .forward)
        _pastLaunches = Query(filter: Launch.predicate(searchText: searchText, onlyPastLaunches: true, startDate: Calendar.current.date(byAdding: .day, value: -7, to: Date()), endDate: Date()), sort: \Launch.net, order: .reverse)
    }

    var body: some View {
        List() {
            ForEach(futureLaunches) { launch in
                LaunchRow(launch: launch)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    .matchedTransitionSource(id: launch.id, in: namespace, configuration: { source in source
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                    })
                    .overlay(
                        NavigationLink("", value: launch).opacity(0)
                    )
            }
            if !pastLaunches.isEmpty {
                Section("Past Launches") {
                    ForEach(pastLaunches) { launch in
                        LaunchRow(launch: launch)
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                            .matchedTransitionSource(id: launch.id, in: namespace, configuration: { source in source
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                            })
                            .overlay(
                                NavigationLink("", value: launch).opacity(0)
                            )
                    }
                }
            }
            AttributionView()
        }
        .navigationDestination(for: Launch.self) {launch in
            LaunchDetailView(launch: launch)
                .navigationTransition(.zoom(sourceID: launch.id, in: namespace))
                .toolbarVisibility(.hidden, for: .navigationBar)
        }
        .listStyle(.plain)
        .listRowSpacing(-6)
   }
}

#if DEBUG
#Preview {
    LaunchList()
        .modelContainer(PreviewSampleData.container)
}
#endif
