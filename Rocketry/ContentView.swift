//
//  ContentView.swift
//  Rocketry
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
            .refreshable { await LaunchResultCollection.refresh(modelContext: modelContext) }
            .onChange(of: scenePhase) {
                Task { await LaunchResultCollection.refresh(modelContext: modelContext) }
            }
            .task { await LaunchResultCollection.refresh(modelContext: modelContext) }
            .preferredColorScheme(.dark)
            .scrollIndicators(.never)
        }
    }
}

 #Preview {
     ContentView()
         .modelContainer(for: Launch.self, inMemory: true)
 }
