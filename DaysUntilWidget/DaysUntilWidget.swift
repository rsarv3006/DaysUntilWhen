//
//  DaysUntilWidget.swift
//  DaysUntilWidget
//
//  Created by Robert J. Sarvis Jr on 11/17/23.
//

import WidgetKit
import SwiftUI
import SwiftData

struct Provider: TimelineProvider {
    let modelContext = ModelContext(DataGeneration.container)
   
    init() {
        DataGeneration.generateAllData(context: modelContext)
    }
    
    func placeholder(in context: Context) -> SimpleEntry {
        let holidays = try! modelContext.fetch(FetchDescriptor<Holiday>())
        let displayOptions = try! modelContext.fetch(FetchDescriptor<HolidayDisplayOptions>())
        
        let selectedHoliday = HolidaysUtils.getSelectedHoliday(holidays: holidays, date: .now)
        
        let displayOption = displayOptions.first(where: { $0.id == selectedHoliday?.variant })
        
        return SimpleEntry(date: .now, holiday: selectedHoliday!, background: (displayOption?.backgroundOption)!, text: (displayOption?.textOption)!)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let holidays = try! modelContext.fetch(FetchDescriptor<Holiday>())
        let displayOptions = try! modelContext.fetch(FetchDescriptor<HolidayDisplayOptions>())
        
        let selectedHoliday = HolidaysUtils.getSelectedHoliday(holidays: holidays, date: .now)
        
        let displayOption = displayOptions.first(where: { $0.id == selectedHoliday?.variant })
        
        let entry = SimpleEntry(date: .now, holiday: selectedHoliday!, background: (displayOption?.backgroundOption)!, text: (displayOption?.textOption)!)
        
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
      
        let holidays = try! modelContext.fetch(FetchDescriptor<Holiday>())
        let displayOptions = try! modelContext.fetch(FetchDescriptor<HolidayDisplayOptions>())
        
        var entries: [SimpleEntry] = []

        let currentDate = Calendar.current.startOfDay(for: Date())
        for dayOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .day, value: dayOffset, to: currentDate)!
            let selectedHoliday = HolidaysUtils.getSelectedHoliday(holidays: holidays, date: entryDate)
          
            let displayOption = displayOptions.first(where: { $0.id == selectedHoliday?.variant })
            
            let entry = SimpleEntry(date: entryDate, holiday: selectedHoliday!, background: (displayOption?.backgroundOption)!, text: (displayOption?.textOption)!)
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
//        .supportedFamilies([.systemSmall, .systemLarge])
    }
}

#Preview(as: .systemSmall) {
    DaysUntilWidget()
} timeline: {
    SimpleEntry(date: .now, holiday: Holiday(id: Date.christmas?.timeIntervalSince1970 ?? Date().timeIntervalSince1970, variant: .christmas, name: "Christmas", holidayDescription: "Christmas Day!", dayOfGreeting: "Merry Christmas"), background: BackgroundOption(id: BackgroundOptionId.ChristmasBackground1.rawValue, type: .image), text: TextOption(id: TextOptionId.ChristmasRed.rawValue))
    SimpleEntry(date: .tomorrow, holiday: Holiday(id: Date.christmas?.timeIntervalSince1970 ?? Date().timeIntervalSince1970, variant: .christmas, name: "Christmas", holidayDescription: "Christmas Day!", dayOfGreeting: "Merry Christmas"), background: BackgroundOption(id: BackgroundOptionId.ChristmasBackground1.rawValue, type: .image), text: TextOption(id: TextOptionId.ChristmasRed.rawValue))
    SimpleEntry(date: .christmas!, holiday: Holiday(id: Date.christmas?.timeIntervalSince1970 ?? Date().timeIntervalSince1970, variant: .christmas, name: "Christmas", holidayDescription: "Christmas Day!", dayOfGreeting: "Merry Christmas"), background: BackgroundOption(id: BackgroundOptionId.ChristmasBackground1.rawValue, type: .image), text: TextOption(id: TextOptionId.ChristmasRed.rawValue))
    SimpleEntry(date: .dayAfterChristmas!, holiday: createNewYearHolidayModel(newYearTimeInterval: DateComponents(calendar: .current, year: Date.currentYear + 1, month: 1, day: 1).date!.timeIntervalSince1970), background: BackgroundOption(id: BackgroundOptionId.ChristmasBackground1.rawValue, type: .image), text: TextOption(id: TextOptionId.ChristmasRed.rawValue))
    
}
