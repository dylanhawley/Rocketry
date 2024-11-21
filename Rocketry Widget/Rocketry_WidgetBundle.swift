//
//  Rocketry_WidgetBundle.swift
//  Rocketry Widget
//
//  Created by Dylan Hawley on 10/16/23.
//

import WidgetKit
import SwiftUI

@main
struct Rocketry_WidgetBundle: WidgetBundle {
    var body: some Widget {
        Rocketry_Widget()
        Rocketry_WidgetLiveActivity()
    }
}
