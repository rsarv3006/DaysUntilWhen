import SwiftUI
import WidgetKit

struct DaysUntilWidgetEntryView: View {
    var entry: Provider.Entry
   
    private var daysUntilHoliday: Int {
        return  HolidaysUtils.daysUntil(entry.date, entry.holiday?.date) ?? 0
    }
    
    private var isHolidayNameLong: Bool {
        let val = entry.holiday?.name.count ?? 10 > 10
        return val
    }
    
    var body: some View {
        VStack {
            if daysUntilHoliday > 0 {
                Text("\(daysUntilHoliday)")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(entry.text?.color ?? .primary)
                Text(daysUntilHoliday == 1 ? "Day until" : "Days until")
                    .foregroundStyle(entry.text?.color ?? .primary)
                Text(entry.holiday?.name ?? "UH OH No Holiday Found :(")
                    .font(.system(size: isHolidayNameLong ? 17 : 25))
                    .fontWeight(.bold)
                    .foregroundStyle(entry.text?.color ?? .primary)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, isHolidayNameLong ? 24 : 0)
                    .lineLimit(2)
                    .minimumScaleFactor(0.7)
            } else {
                Text(entry.holiday?.dayOfGreeting ?? "UH OH No Holiday Found :(")
                    .font(.system(size: 24))
                    .fontWeight(.bold)
                    .foregroundStyle(entry.text?.color ?? .primary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.7)
            }
        }
        .containerBackground(for: .widget) {
            if let backgroundImage = entry.background?.image {
                backgroundImage
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else if let backgroundColor =
                        entry.background?.color {
                backgroundColor
            }
        }
    }
}
