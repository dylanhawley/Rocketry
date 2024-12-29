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
    @AppStorage("usePadTimeZone") private var usePadTimeZone: Bool = false
    @State private var showingSettings = false

    var body: some View {
        NavigationStack {
            LaunchList(searchText: searchText)
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search Launches")
            .navigationTitle("Launches")
            .refreshable { await LaunchResultCollection.refresh(modelContext: modelContext) }
            .onChange(of: scenePhase) {
                Task { await LaunchResultCollection.refresh(modelContext: modelContext) }
            }
            .task { await LaunchResultCollection.refresh(modelContext: modelContext) }
            .preferredColorScheme(.dark)
            .scrollIndicators(.never)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Picker(selection: $usePadTimeZone, label: Text("Select Timezone")) {
                            Text("System Timezone").tag(false)
                            Text("Launch Pad Timezone").tag(true)
                        }
                        Button{showingSettings.toggle()} label: {
                            Label("Settings", systemImage: "gear")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                    .foregroundStyle(Color.white)
                }
            }
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
    }
}

 #Preview {
     ContentView()
         .modelContainer(for: Launch.self, inMemory: true)
 }
