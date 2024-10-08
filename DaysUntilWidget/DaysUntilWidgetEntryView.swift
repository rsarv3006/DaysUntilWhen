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
        return  HolidaysUtils.daysUntil(entry.date, entry.holiday.date) ?? 0
    }
    
    private var isHolidayNameLong: Bool {
        let val = entry.holiday.name.count > 10
        return val
    }
    
    var body: some View {
        VStack {
            if daysUntilHoliday > 0 {
                Text("\(daysUntilHoliday)")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(entry.text.color ?? .primary)
                Text(daysUntilHoliday == 1 ? "Day until" : "Days until")
                    .foregroundStyle(entry.text.color ?? .primary)
                Text(entry.holiday.name)
                    .font(.system(size: isHolidayNameLong ? 17 : 25))
                    .fontWeight(.bold)
                    .foregroundStyle(entry.text.color ?? .primary)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, isHolidayNameLong ? 24 : 0)
            } else {
                Text(entry.holiday.dayOfGreeting)
                    .font(.system(size: 24))
                    .fontWeight(.bold)
                    .foregroundStyle(entry.text.color ?? .primary)
                    .multilineTextAlignment(.center)
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
    SimpleEntry(date: .now, holiday: createMothersDayHolidayModel(mothersTimeInterval: Date.christmas?.timeIntervalSince1970 ?? Date().timeIntervalSince1970), background: BackgroundOption(id: BackgroundOptionId.ChristmasBackground1.rawValue, type: .image), text: TextOption(id: TextOptionId.ChristmasRed.rawValue, optionName: "Christmas Red"))
    SimpleEntry(date: .now, holiday: createChristmasHolidayModel(christmasTimeInterval: Date.christmas?.timeIntervalSince1970 ?? Date().timeIntervalSince1970), background: BackgroundOption(id: BackgroundOptionId.ChristmasBackground1.rawValue, type: .image), text: TextOption(id: TextOptionId.ChristmasRed.rawValue, optionName: "Christmas Red"))
    SimpleEntry(date: .tomorrow, holiday: createChristmasHolidayModel(christmasTimeInterval: Date.christmas?.timeIntervalSince1970 ?? Date().timeIntervalSince1970), background: BackgroundOption(id: BackgroundOptionId.ChristmasBackground1.rawValue, type: .image), text: TextOption(id: TextOptionId.ChristmasRed.rawValue, optionName: "Christmas Red"))
    SimpleEntry(date: .christmas!, holiday: createChristmasHolidayModel(christmasTimeInterval: Date.christmas?.timeIntervalSince1970 ?? Date().timeIntervalSince1970), background: BackgroundOption(id: BackgroundOptionId.ChristmasBackground1.rawValue, type: .image), text: TextOption(id: TextOptionId.ChristmasRed.rawValue, optionName: "Christmas Red"))
}

