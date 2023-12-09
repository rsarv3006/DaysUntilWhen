//
//  WidgetPickers.swift
//  DaysUntil
//
//  Created by Robert J. Sarvis Jr on 11/20/23.
//

import SwiftUI
import SwiftData

struct WidgetPickers: View {
    @Query var allHolidays: [Holiday]
    @Query var backgroundOptions: [BackgroundOption]
    @Query var textOptions: [TextOption]
    
    @Binding var selectedHoliday: Holiday
    @Binding var selectedBackground: BackgroundOption
    @Binding var selectedText: TextOption
  
    func buildHolidayListDisplayString(_ holiday: Holiday) -> String {
        if let holidayDate = holiday.date {
            return "\(holiday.name) - \(holidayDate.year)"
        }
        
        return holiday.name
    }
    
    var body: some View {
        HStack {
            Text("Holiday:")
            Picker("Selected Holiday", selection: $selectedHoliday) {
                ForEach(allHolidays, id: \.self) { holiday in
                    Text(buildHolidayListDisplayString(holiday))
                }
            }
        }
        
        HStack {
            Text("Background:")
            Picker("Selected Background", selection: $selectedBackground) {
                ForEach(backgroundOptions, id: \.self) { background in
                    Text(background.optionName)
                }
            }
        }
        
        HStack {
            Text("Text:")
            Picker("Selected Text Color", selection: $selectedText) {
                ForEach(textOptions, id: \.self) { text in
                    Text(text.optionName)
                }
            }
        }
    }
}

#Preview {
    let holiday = createChristmasHolidayModel(christmasTimeInterval: Date.christmas?.timeIntervalSince1970 ?? Date().timeIntervalSince1970)
    let background = BackgroundOption(id: .ChristmasBackground1, type: .image)
    let text = TextOption(id: .ChristmasRed, optionName: "Christmas Red")
    
    return (
    WidgetPickers(selectedHoliday: .constant(holiday), selectedBackground: .constant(background), selectedText: .constant(text))
    )
}
