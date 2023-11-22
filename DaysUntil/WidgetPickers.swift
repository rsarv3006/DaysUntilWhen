//
//  WidgetPickers.swift
//  DaysUntil
//
//  Created by Robert J. Sarvis Jr on 11/20/23.
//

import SwiftUI

struct WidgetPickers: View {
    @Binding var selectedHoliday: Holiday
    @Binding var selectedBackground: BackgroundOption
    @Binding var selectedText: TextOption
   
    var body: some View {
        HStack {
            Text("Holiday:")
            Picker("Selected Holiday", selection: $selectedHoliday) {
                ForEach(HolidaysList, id: \.self) { holiday in
                    Text(holiday.name)
                }
            }
        }
        
        HStack {
            Text("Background:")
            Picker("Selected Background", selection: $selectedBackground) {
                ForEach(BackgroundOptionsList, id: \.self) { background in
                    Text(background.optionName)
                }
            }
        }
        
        HStack {
            Text("Text:")
            Picker("Selected Text Color", selection: $selectedText) {
                ForEach(TextOptionsList, id: \.self) { text in
                    Text(text.optionName)
                }
            }
        }
    }
}

#Preview {
    WidgetPickers(selectedHoliday: .constant(HolidaysList[0]), selectedBackground: .constant(BackgroundOptionsList[0]), selectedText: .constant(TextOptionsList[0]))
}
