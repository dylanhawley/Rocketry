//
//  AboutView.swift
//  Rocketry
//
//  Created by Dylan Hawley on 12/31/24.
//

import SwiftUI

struct AboutView: View {
    private var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "N/A"
    }
    
    private var buildNumber: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "N/A"
    }
    
    var body: some View {
        NavigationView {
            Form {
                // MARK: - App Information
                Section(header: Text("App Information")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text(appVersion)
                    }
                    HStack {
                        Text("Build")
                        Spacer()
                        Text(buildNumber)
                    }
                }
                
                // MARK: - Developer Info
                Section(header: Text("Developer")) {
                    Text("Dylan Hawley")
                    Link("Contact Developer", destination: URL(string: "mailto:dylanthomashawley@gmail.com")!)
                }
            }
            .navigationTitle("Rocketry")
        }
        .navigationTitle("About")
    }
}

#Preview {
    AboutView()
}
