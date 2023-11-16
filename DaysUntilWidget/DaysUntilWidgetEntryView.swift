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

    var body: some View {
        VStack {
            Text("\(HolidaysUtils.daysUntil(entry.date, entry.holiday.date) ?? 0)")
            Text("Days until")
            Text(entry.holiday.name)
        }
    }
}

#Preview(as: .systemSmall) {
    DaysUntilWidget()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley, holiday: HolidaysList[0])
    SimpleEntry(date: .now, configuration: .smiley, holiday: HolidaysList[0])
}

