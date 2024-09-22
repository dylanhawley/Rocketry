//
//  ContentView.swift
//  T Minus
//
//  Created by Dylan Hawley on 10/16/23.
//

import SwiftUI
import SwiftData

/// The app's top level navigation split view.
struct ContentView: View {
    @Environment(ViewModel.self) private var viewModel
    @Environment(\.modelContext) private var modelContext
    @Environment(\.scenePhase) private var scenePhase

    @Query private var launches: [Launch]
    @State private var selectedId: Launch.ID? = nil
    @State private var selectedIdMap: Launch.ID? = nil

    var body: some View {
        @Bindable var viewModel = viewModel

        LaunchList(
            selectedId: $selectedId,
            sortOrder: viewModel.sortOrder
        )
        .navigationTitle("Launches")
        .refreshable {
            await refreshData()
        }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active {
                Task { await refreshData() }
            }
        }
        .task {
            await refreshData()
        }
    }

    private func refreshData() async {
        await LaunchResultCollection.refresh(modelContext: modelContext)
        viewModel.update(modelContext: modelContext)
    }
}

 #Preview {
     ContentView()
         .environment(ViewModel())
         .modelContainer(for: Launch.self, inMemory: true)
 }
