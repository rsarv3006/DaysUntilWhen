//
//  DaysUntilEntryWidgetView.swift
//  DaysUntilWidgetExtension
//
//  Created by Robert J. Sarvis Jr on 11/15/23.
//

import SwiftUI
import WidgetKit

struct DaysUntilWidgetEntryView: View {
    var entry: Provider.Entry
    var background: BackgroundOption
    var text: TextOption
   
    private var daysUntilHoliday: Int {
        return HolidaysUtils.daysUntil(entry.date, entry.holiday.date) ?? 0
    }
    
    var body: some View {
        VStack {
            if daysUntilHoliday > 0 {
                Text("\(daysUntilHoliday)")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(text.color ?? .primary)
                Text("Days until")
                    .foregroundStyle(text.color ?? .primary)
                Text(entry.holiday.name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(text.color ?? .primary)
            } else {
                Text(entry.holiday.dayOfMessage)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(text.color ?? .primary)
            }
        }
        .containerBackground(for: .widget) {
            if let backgroundImage = background.image {
                backgroundImage
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else if let backgroundColor =
                        background.color {
                backgroundColor
            }
        }
    }
}

#Preview(as: .systemSmall) {
    DaysUntilWidget()
} timeline: {
    SimpleEntry(date: .now, holiday: HolidaysList[0])
    SimpleEntry(date: .tomorrow, holiday: HolidaysList[0])
    SimpleEntry(date: DateComponents(calendar: .current, year: 2023, month: 12, day: 25).date!, holiday: HolidaysList[0])
}

