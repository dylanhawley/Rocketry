//
//  LaunchList.swift
//  T Minus
//
//  Created by Dylan Hawley on 8/27/24.
//

import SwiftUI
import SwiftData

/// The sorted and filtered list of earthquakes that the app stores.
struct LaunchList: View {
    @Environment(ViewModel.self) private var viewModel
    @Environment(\.modelContext) private var modelContext
    @Query private var launches: [Launch]

    @Binding var selectedId: Launch.ID?

    init(
        selectedId: Binding<Launch.ID?>,
        sortOrder: SortOrder = .reverse
    ) {
        _selectedId = selectedId
        _launches = Query(sort: \Launch.net, order: sortOrder)
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
