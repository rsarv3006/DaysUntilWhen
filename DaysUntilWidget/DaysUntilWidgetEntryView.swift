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
   
    private var daysUntilHoliday: Int {
        return HolidaysUtils.daysUntil(entry.date, entry.holiday.date) ?? 0
    }
    
    var body: some View {
        VStack {
            if daysUntilHoliday > 0 {
                Text("\(daysUntilHoliday)")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(entry.text.color ?? .primary)
                Text("Days until")
                    .foregroundStyle(entry.text.color ?? .primary)
                Text(entry.holiday.name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(entry.text.color ?? .primary)
            } else {
                Text(entry.holiday.dayOfGreeting)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(entry.text.color ?? .primary)
            }
        }
        .containerBackground(for: .widget) {
            if let backgroundImage = entry.background.image {
                backgroundImage
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else if let backgroundColor =
                        entry.background.color {
                backgroundColor
            }
        }
    }
}

#Preview(as: .systemSmall) {
    DaysUntilWidget()
} timeline: {
    SimpleEntry(date: .now, holiday: HolidaysList[0], background: BackgroundOptionsList[0], text: TextOptionsList[0])
    SimpleEntry(date: .tomorrow, holiday: HolidaysList[0], background: BackgroundOptionsList[0], text: TextOptionsList[0])
    SimpleEntry(date: .christmas!, holiday: HolidaysList[0], background: BackgroundOptionsList[0], text: TextOptionsList[0])
}

