//
//  GoodToWatchView.swift
//  Rocketry
//
//  Created by Dylan Hawley on 12/16/24.
//

import SwiftUI

struct GoodToWatchView: View {
    var body: some View {
        Label("Good Viewing Conditions", systemImage: "eye.fill")
        .foregroundColor(.green)
        .frame(maxWidth: .infinity, alignment: .leading)
        .imageScale(.small)
    }
}

#Preview {
    GoodToWatchView()
}
