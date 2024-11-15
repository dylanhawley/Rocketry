//
//  ContentView.swift
//  T Minus
//
//  Created by Dylan Hawley on 10/16/23.
//

import SwiftUI
import SwiftData


struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.scenePhase) private var scenePhase

    @Query private var launches: [Launch]
    @State private var searchText: String = String()

    var body: some View {
        NavigationStack {
            LaunchList(searchText: searchText)
            .searchable(text: $searchText, prompt: "Search Launches")
            .navigationTitle("Launches")
            .refreshable { await refreshData() }
            .onChange(of: scenePhase) { _, newPhase in
                if newPhase == .active {
                    Task { await refreshData() }
                }
            }
            .task { await refreshData() }
            .preferredColorScheme(.dark)
            .scrollIndicators(.never)
        }
        .accentColor(.white)
    }

    private func refreshData() async {
        await LaunchResultCollection.refresh(modelContext: modelContext)
    }
}

 #Preview {
     ContentView()
         .modelContainer(for: Launch.self, inMemory: true)
 }
