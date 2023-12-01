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
        SimpleEntry(date: Date(), holiday: HolidaysList[0], background: BackgroundOptionsList[0], text: TextOptionsList[0])
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let holidayIndex = UserDefaultsService.integer(forKey: .selectedHolidayIndex)
        let backgroundIndex = UserDefaultsService.integer(forKey: .selectedBackgroundIndex)
        let textIndex = UserDefaultsService.integer(forKey: .selectedTextIndex)
        
        let selectedHoliday = HolidaysList[holidayIndex]
        let selectedBackground = BackgroundOptionsList[backgroundIndex]
        let selectedText = TextOptionsList[textIndex]
        
        let entry = SimpleEntry(date: Date(), holiday: selectedHoliday, background: selectedBackground, text: selectedText)
        
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        let holidayIndex = UserDefaultsService.integer(forKey: .selectedHolidayIndex)
        let backgroundIndex = UserDefaultsService.integer(forKey: .selectedBackgroundIndex)
        let textIndex = UserDefaultsService.integer(forKey: .selectedTextIndex)
        
        let selectedHoliday = HolidaysList[holidayIndex]
        let selectedBackground = BackgroundOptionsList[backgroundIndex]
        let selectedText = TextOptionsList[textIndex]
        
        var entries: [SimpleEntry] = []

        let currentDate = Calendar.current.startOfDay(for: Date())
        for dayOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .day, value: dayOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, holiday: selectedHoliday, background: selectedBackground, text: selectedText)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let holiday: Holiday
    let background: BackgroundOption
    let text: TextOption
}

struct DaysUntilWidget: Widget {
    let kind: String = "DaysUntilWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                DaysUntilWidgetEntryView(entry: entry)
            } else {
                DaysUntilWidgetEntryView(entry: entry)
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
    SimpleEntry(date: .now, holiday: HolidaysList[0], background: BackgroundOptionsList[0], text: TextOptionsList[0])
    SimpleEntry(date: .tomorrow, holiday: HolidaysList[0], background: BackgroundOptionsList[0], text: TextOptionsList[0])
    SimpleEntry(date: .dayAfterChristmas!, holiday: HolidaysList[0], background: BackgroundOptionsList[0], text: TextOptionsList[0])
}
