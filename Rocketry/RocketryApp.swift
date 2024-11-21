//
//  RocketryApp.swift
//  Rocketry
//
//  Created by Dylan Hawley on 10/16/23.
//

import SwiftUI
import SwiftData

@main
struct RocketryApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Launch.self)
    }
}
