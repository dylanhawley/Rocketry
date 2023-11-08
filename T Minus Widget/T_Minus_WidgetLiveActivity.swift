//
//  T_Minus_WidgetLiveActivity.swift
//  T Minus Widget
//
//  Created by Dylan Hawley on 10/16/23.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct T_Minus_WidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct T_Minus_WidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: T_Minus_WidgetAttributes.self) { context in
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

extension T_Minus_WidgetAttributes {
    fileprivate static var preview: T_Minus_WidgetAttributes {
        T_Minus_WidgetAttributes(name: "World")
    }
}

extension T_Minus_WidgetAttributes.ContentState {
    fileprivate static var smiley: T_Minus_WidgetAttributes.ContentState {
        T_Minus_WidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: T_Minus_WidgetAttributes.ContentState {
         T_Minus_WidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: T_Minus_WidgetAttributes.preview) {
   T_Minus_WidgetLiveActivity()
} contentStates: {
    T_Minus_WidgetAttributes.ContentState.smiley
    T_Minus_WidgetAttributes.ContentState.starEyes
}
