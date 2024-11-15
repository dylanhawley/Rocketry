//
//  LaunchList.swift
//  T Minus
//
//  Created by Dylan Hawley on 8/27/24.
//

import SwiftUI
import SwiftData


struct LaunchList: View {
    @Environment(ViewModel.self) private var viewModel
    @Environment(\.modelContext) private var modelContext
    @Query private var futureLaunches: [Launch]
    @Query private var pastLaunches: [Launch]

    @Binding var selectedId: Launch.ID?

    init(
        selectedId: Binding<Launch.ID?>,
        searchText: String = "",
        sortOrder: SortOrder = .forward
    ) {
        _selectedId = selectedId
        _futureLaunches = Query(filter: Launch.predicate(searchText: searchText, onlyFutureLaunches: true), sort: \Launch.net, order: sortOrder)
        _pastLaunches = Query(filter: Launch.predicate(searchText: searchText, onlyPastLaunches: true, startDate: Calendar.current.date(byAdding: .day, value: -7, to: Date()), endDate: Date()), sort: \Launch.net, order: .reverse)
    }

    var body: some View {
        List(selection: $selectedId) {
            ForEach(futureLaunches) { launch in
                LaunchRow(launch: launch)
                    .padding(.vertical, -6)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    .background(
                        NavigationLink("", destination: LaunchDetailView(launch: launch)).opacity(0)
                    )
            }
            if !pastLaunches.isEmpty {
                Section("Past Launches") {
                    ForEach(pastLaunches) { launch in
                        LaunchRow(launch: launch)
                            .padding(.vertical, -6)
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                            .background(
                                NavigationLink("", destination: LaunchDetailView(launch: launch)).opacity(0)
                            )
                    }
                }
            }
        }
        .listStyle(.plain)
   }
}

#if DEBUG
#Preview {
    LaunchList(selectedId: .constant(nil))
        .environment(ViewModel.preview)
        .modelContainer(PreviewSampleData.container)
}
#endif
