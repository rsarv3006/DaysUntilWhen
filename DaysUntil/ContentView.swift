//
//  ContentView.swift
//  DaysUntil
//
//  Created by Robert J. Sarvis Jr on 11/14/23.
//

import SwiftUI
import WidgetKit

struct ContentView: View {
    @AppStorage(DefaultsKey.selectedHolidayIndex.rawValue, store: AppGroup.daysUntilWhen.defaults) var selectedHolidayIndex: Int = 0
    @AppStorage(DefaultsKey.selectedBackgroundIndex.rawValue, store: AppGroup.daysUntilWhen.defaults) var selectedBackgroundIndex: Int = 0
    @AppStorage(DefaultsKey.selectedTextIndex.rawValue, store: AppGroup.daysUntilWhen.defaults) var selectedTextIndex: Int = 0
    
    @State private var selectedHoliday: Holiday = HolidaysList[0]
    @State private var selectedBackground: BackgroundOption = BackgroundOptionsList[0]
    @State private var selectedText: TextOption = TextOptionsList[0]
    
    init() {
        self._selectedHoliday = State(
            initialValue: HolidaysList[selectedHolidayIndex])

        self._selectedBackground = State(
            initialValue: BackgroundOptionsList[selectedBackgroundIndex])

        self._selectedText = State(
            initialValue: TextOptionsList[selectedTextIndex])

    }

    var body: some View {
        NavigationStack {
            VStack {
                VStack(alignment: .leading) {
                    WidgetPickers(selectedHoliday: $selectedHoliday, selectedBackground: $selectedBackground, selectedText: $selectedText)
                        .onChange(of: selectedHoliday) { oldValue, newValue in
                            selectedHolidayIndex = HolidaysList.firstIndex(of: newValue) ?? 0
                            selectedBackground = BackgroundOptionsList[newValue.defaultBackgroundOptionIndex]
                            selectedText = TextOptionsList[newValue.defaultTextOptionIndex]
                            WidgetCenter.shared.reloadTimelines(ofKind: "DaysUntilWidget")
                        }
                        .onChange(of: selectedBackground) { oldValue, newValue in
                            selectedBackgroundIndex = BackgroundOptionsList.firstIndex(of: newValue) ?? 0
                            WidgetCenter.shared.reloadTimelines(ofKind: "DaysUntilWidget")
                        }
                        .onChange(of: selectedText) { oldValue, newValue in
                            selectedTextIndex = TextOptionsList.firstIndex(of: newValue) ?? 0
                            WidgetCenter.shared.reloadTimelines(ofKind: "DaysUntilWidget")
                        }
                }
                .padding(.horizontal)
                .padding(.bottom, 30)
              
                Text("Widget Preview")
                    .font(.title3)
                
                ZStack {
                    if let backgroundImage = selectedBackground.image {
                        backgroundImage
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                            .shadow(radius: 10)
                            .frame(width: 200, height: 200)
                    } else if let backgroundColor =
                                selectedBackground.color {
                        backgroundColor
                            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                            .shadow(radius: 10)
                            .frame(width: 200, height: 200)
                    }
                    
                    DaysUntilWidgetEntryView(entry: .init(date: Date(), holiday: selectedHoliday, background: BackgroundOptionsList[selectedBackgroundIndex], text: TextOptionsList[selectedTextIndex]))
                    
                }
                Spacer()
            }
            .navigationTitle("DaysUntilWhen")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ContentView()
}
