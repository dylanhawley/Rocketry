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
    @State private var viewModel = ViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(viewModel)
        }
        .modelContainer(for: Launch.self)
    }
}
