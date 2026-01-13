//
//  SunriseWidgetExtension.swift
//  SunriseWidgetExtension
//
//  Created by Michael Chen on 1/13/26.
//

import WidgetKit
import SwiftUI

struct SunriseTimelineProvider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), emoji: "🌅")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), emoji: "🌅")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, emoji: "🌅")
            entries.append(entry)
        }
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let emoji: String
}

struct SunriseWidgetExtensionEntryView: View {
    var entry: SunriseTimelineProvider.Entry

    var body: some View {
        VStack {
            Text("Sunrise")
            Text(entry.date, style: .time)
        }
    }
}

struct SunriseWidgetExtension: Widget {
    let kind: String = "SunriseWidgetExtension"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: SunriseTimelineProvider()) { entry in
            if #available(iOS 17.0, *) {
                SunriseWidgetExtensionEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                SunriseWidgetExtensionEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Sunrise")
        .description("Shows sunrise time")
    }
}
