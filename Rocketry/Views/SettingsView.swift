//
//  SettingsView.swift
//  Rocketry
//
//  Created by Dylan Hawley on 12/26/24.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var toggleOption1 = false
    @State private var toggleOption2 = true

    var body: some View {
        NavigationView {
            Form {
                Toggle("Enable Feature X", isOn: $toggleOption1)
                Toggle("Enable Feature Y", isOn: $toggleOption2)
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}
