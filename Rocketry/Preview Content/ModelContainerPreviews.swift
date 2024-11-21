//
//  ModelContainerPreviews.swift
//  Rocketry
//
//  Created by Dylan Hawley on 8/27/24.
//

import SwiftUI
import SwiftData


struct ModelContainerPreview<Content: View>: View {
    var content: () -> Content
    let container: ModelContainer


    init(
        _ modelContainer: @escaping () throws -> ModelContainer,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.content = content
        do {
            self.container = try MainActor.assumeIsolated(modelContainer)
        } catch {
            fatalError("Failed to create the model container: \(error.localizedDescription)")
        }
    }

    var body: some View {
        content()
            .modelContainer(container)
    }
}
