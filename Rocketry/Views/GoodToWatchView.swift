//
//  GoodToWatchView.swift
//  Rocketry
//
//  Created by Dylan Hawley on 12/16/24.
//

import SwiftUI

struct GoodToWatchView: View {
    var body: some View {
        HStack {
            Image(systemName: "eye.fill")
            Text("Good Viewing Conditions")
        }
        .foregroundColor(.green)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    GoodToWatchView()
}
