//
//  Launch_Feed_WidgetBundle.swift
//  T Minus Widget
//
//  Created by Dylan Hawley on 10/16/23.
//

import WidgetKit
import SwiftUI

@main
struct Launch_Feed_WidgetBundle: WidgetBundle {
    var body: some Widget {
        Launch_Feed_Widget()
        Launch_Feed_WidgetLiveActivity()
    }
}
