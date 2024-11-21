//
//  Rocketry_WidgetLiveActivity.swift
//  Rocketry Widget
//
//  Created by Dylan Hawley on 10/16/23.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct Rocketry_WidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct Rocketry_WidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: Rocketry_WidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension Rocketry_WidgetAttributes {
    fileprivate static var preview: Rocketry_WidgetAttributes {
        Rocketry_WidgetAttributes(name: "World")
    }
}

extension Rocketry_WidgetAttributes.ContentState {
    fileprivate static var smiley: Rocketry_WidgetAttributes.ContentState {
        Rocketry_WidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: Rocketry_WidgetAttributes.ContentState {
         Rocketry_WidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: Rocketry_WidgetAttributes.preview) {
   Rocketry_WidgetLiveActivity()
} contentStates: {
    Rocketry_WidgetAttributes.ContentState.smiley
    Rocketry_WidgetAttributes.ContentState.starEyes
}
