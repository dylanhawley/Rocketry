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
    @Query private var launches: [Launch]

    @Binding var selectedId: Launch.ID?

    init(
        selectedId: Binding<Launch.ID?>,
        searchText: String = "",
        sortOrder: SortOrder = .forward
    ) {
        _selectedId = selectedId
        _launches = Query(filter: Launch.predicate(searchText: searchText, onlyFutureLaunches: false), sort: \Launch.net, order: sortOrder)
    }

    var body: some View {
        List(launches, selection: $selectedId) { launch in
            LaunchRow(launch: launch)
            .listRowInsets(EdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 15))
            .listRowSeparator(.hidden)
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
