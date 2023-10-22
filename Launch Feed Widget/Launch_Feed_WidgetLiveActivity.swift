//
//  Launch_Feed_WidgetLiveActivity.swift
//  Launch Feed Widget
//
//  Created by Dylan Hawley on 10/16/23.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct Launch_Feed_WidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct Launch_Feed_WidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: Launch_Feed_WidgetAttributes.self) { context in
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

extension Launch_Feed_WidgetAttributes {
    fileprivate static var preview: Launch_Feed_WidgetAttributes {
        Launch_Feed_WidgetAttributes(name: "World")
    }
}

extension Launch_Feed_WidgetAttributes.ContentState {
    fileprivate static var smiley: Launch_Feed_WidgetAttributes.ContentState {
        Launch_Feed_WidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: Launch_Feed_WidgetAttributes.ContentState {
         Launch_Feed_WidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: Launch_Feed_WidgetAttributes.preview) {
   Launch_Feed_WidgetLiveActivity()
} contentStates: {
    Launch_Feed_WidgetAttributes.ContentState.smiley
    Launch_Feed_WidgetAttributes.ContentState.starEyes
}
