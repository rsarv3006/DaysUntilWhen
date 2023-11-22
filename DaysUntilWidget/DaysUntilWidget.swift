//
//  DaysUntilWidget.swift
//  DaysUntilWidget
//
//  Created by Robert J. Sarvis Jr on 11/17/23.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), holiday: HolidaysList[0])
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), holiday: HolidaysList[0])
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, holiday: HolidaysList[0])
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let holiday: Holiday
}

struct DaysUntilWidget: Widget {
    let kind: String = "DaysUntilWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                DaysUntilWidgetEntryView(entry: entry, background: BackgroundOptionsList[0], text: TextOptionsList[0])
            } else {
                DaysUntilWidgetEntryView(entry: entry, background: BackgroundOptionsList[0], text: TextOptionsList[0])
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Days Until When")
        .description("Showing Days until a holiday!")
        .supportedFamilies([.systemSmall, .systemLarge])
    }
}

#Preview(as: .systemSmall) {
    DaysUntilWidget()
} timeline: {
    SimpleEntry(date: .now, holiday: HolidaysList[0])
    SimpleEntry(date: .now, holiday: HolidaysList[0])
}
