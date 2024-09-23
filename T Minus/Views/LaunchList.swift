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
        _launches = Query(sort: \Launch.net, order: sortOrder)
        
        let predicate = Launch.predicate(searchText: searchText)
        _launches = Query(filter: predicate, sort: \Launch.net, order: .forward)
        
    }

    var body: some View {
        List(launches, selection: $selectedId) { launch in
            LaunchRow(launch: launch)
        }
   }
}

#Preview {
    LaunchList(selectedId: .constant(nil))
        .environment(ViewModel.preview)
        .modelContainer(PreviewSampleData.container)
}
