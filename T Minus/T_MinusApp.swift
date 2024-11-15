//
//  T_MinusApp.swift
//  T Minus
//
//  Created by Dylan Hawley on 10/16/23.
//

import SwiftUI
import SwiftData

@main
struct T_MinusApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Launch.self)
    }
}
