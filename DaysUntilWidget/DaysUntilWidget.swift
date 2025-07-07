import WidgetKit
import SwiftUI
import GRDB

struct Provider: TimelineProvider {
    let appDatabase: AppDatabase
   
    init() {
        self.appDatabase = AppDatabase.shared
    }
    
    func placeholder(in context: Context) -> SimpleEntry {
        do {
            return try appDatabase.reader.read { db in
                let holidays = try appDatabase.getAllHolidays(in: db)
                let displayOptions = try appDatabase.getAllDisplayOptions(in: db)
                let userEnabledDisplayEntities = try appDatabase.getAllUserEnableHolidayEntities(in: db)
                
                let selectedHoliday = HolidaysUtils.getSelectedHoliday(holidays: holidays, date: .now, userEnabledHolidays: userEnabledDisplayEntities)
                
                var backgroundOption: GRDBBackgroundOption? = nil
                var textOption: GRDBTextOption? = nil
                
                if let displayOption = displayOptions.first(where: { $0.id == selectedHoliday?.variant }) {
                    let options = try displayOption.getDisplayOptions(in: db)
                    backgroundOption = options.backgroundOption
                    textOption = options.textOption
                }
                
                return SimpleEntry(
                    date: .now,
                    holiday: selectedHoliday,
                    background: backgroundOption,
                    text: textOption
                )
            }
        } catch {
            return SimpleEntry(date: .now, holiday: nil, background: nil, text: nil)
        }
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        do {
            try appDatabase.reader.read { db in
                let holidays = try appDatabase.getAllHolidays(in: db)
                let displayOptions = try appDatabase.getAllDisplayOptions(in: db)
                let userEnabledDisplayEntities = try appDatabase.getAllUserEnableHolidayEntities(in: db)
                
                let selectedHoliday = HolidaysUtils.getSelectedHoliday(holidays: holidays, date: .now, userEnabledHolidays: userEnabledDisplayEntities)
                
                var backgroundOption: GRDBBackgroundOption? = nil
                var textOption: GRDBTextOption? = nil
                
                if let displayOption = displayOptions.first(where: { $0.id == selectedHoliday?.variant }) {
                    let options = try displayOption.getDisplayOptions(in: db)
                    backgroundOption = options.backgroundOption
                    textOption = options.textOption
                }
                
                let entry = SimpleEntry(
                    date: .now,
                    holiday: selectedHoliday,
                    background: backgroundOption,
                    text: textOption
                )
                
                completion(entry)
            }
        } catch {
            completion(SimpleEntry(date: .now, holiday: nil, background: nil, text: nil))
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        do {
            try appDatabase.reader.read { db in
                let holidays = try appDatabase.getAllHolidays(in: db)
                let displayOptions = try appDatabase.getAllDisplayOptions(in: db)
                let userEnabledDisplayEntities = try appDatabase.getAllUserEnableHolidayEntities(in: db)
                
                
                let currentDate = Calendar.current.startOfDay(for: Date())
                for dayOffset in 0 ..< 5 {
                    guard let entryDate = Calendar.current.date(byAdding: .day, value: dayOffset, to: currentDate) else {
                        continue
                    }
                    
                    let selectedHoliday = HolidaysUtils.getSelectedHoliday(holidays: holidays, date: entryDate, userEnabledHolidays: userEnabledDisplayEntities)
                    
                    var backgroundOption: GRDBBackgroundOption? = nil
                    var textOption: GRDBTextOption? = nil
                    
                    if let displayOption = displayOptions.first(where: { $0.id == selectedHoliday?.variant }) {
                        let options = try displayOption.getDisplayOptions(in: db)
                        backgroundOption = options.backgroundOption
                        textOption = options.textOption
                    }
                    
                    let entry = SimpleEntry(
                        date: entryDate,
                        holiday: selectedHoliday,
                        background: backgroundOption,
                        text: textOption
                    )
                    entries.append(entry)
                }
                
                let timeline = Timeline(entries: entries, policy: .atEnd)
                completion(timeline)
            }
        } catch {
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let holiday: GRDBHoliday?
    let background: GRDBBackgroundOption?
    let text: GRDBTextOption?
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
    }
}
