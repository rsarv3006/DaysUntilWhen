//
//  WidgetPreviewView.swift
//  DaysUntil
//
//  Created by Robert J. Sarvis Jr on 12/6/23.
//

import SwiftUI
import SwiftData
import WidgetKit

struct WidgetPreviewView: View {
    @Query var holidays: [Holiday]
    @Query var displayOptions: [HolidayDisplayOptions]
    
    @State private var selectedHoliday: Holiday = createChristmasHolidayModel(christmasTimeInterval: Date.christmas?.timeIntervalSince1970 ?? Date().timeIntervalSince1970)
    @State private var selectedBackground: BackgroundOption = BackgroundOption(id: .ChristmasBackground1, type: .image)
    @State private var selectedText: TextOption = TextOption(id: .ChristmasRed)
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack(alignment: .leading) {
                    WidgetPickers(selectedHoliday: $selectedHoliday, selectedBackground: $selectedBackground, selectedText: $selectedText)
                        .onChange(of: selectedHoliday) { oldValue, newValue in
                            if let displayOption = displayOptions.first(where: { $0.id == selectedHoliday.variant }), let backgroundOption = displayOption.backgroundOption, let textOption = displayOption.textOption {
                                selectedBackground = backgroundOption
                                selectedText = textOption
                            }
                        }
                }
                .padding(.horizontal)
                .padding(.bottom, 30)
                
                Text("Widget Preview")
                    .font(.title3)
                
                ZStack {
                    if let backgroundImage = selectedBackground.image {
                        backgroundImage
                            .styledBackgroundImageWidgetPreview()
                    } else if let backgroundColor =
                                selectedBackground.color {
                        backgroundColor
                            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                            .shadow(radius: 10)
                            .frame(width: 200, height: 200)
                    }
                    
                    DaysUntilWidgetEntryView(entry: .init(date: Date(), holiday: selectedHoliday , background: selectedBackground, text: selectedText))
                    
                }
                
                Button("Update Widget") {
                    updateWidget()
                }
                .padding(.top)
                
                Spacer()
            }
            .navigationTitle("DaysUntilWhen")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            loadState()
        }
        .onChange(of: holidays) { oldValue, newValue in
            loadState()
        }
    }
    
    private func loadState() {
        if let foundHoliday = HolidaysUtils.getSelectedHoliday(holidays: holidays, date: Date()) {
            
            selectedHoliday = foundHoliday
            
            if let displayOption = displayOptions.first(where: { $0.id == selectedHoliday.variant }), let backgroundOption = displayOption.backgroundOption, let textOption = displayOption.textOption {
                selectedBackground = backgroundOption
                selectedText = textOption
            }
        }
    }
    
    private func updateWidget() {
        holidays.forEach { holiday in
            holiday.isFavorite = false
        }

        selectedHoliday.isFavorite = true
        
        let displayOption = displayOptions.first(where: { $0.id == selectedHoliday.variant })
        
        displayOption?.updateDisplayOptions(backgroundOption: selectedBackground, textOption: selectedText)
        
        WidgetCenter.shared.reloadAllTimelines()
    }
}

#Preview {
    WidgetPreviewView()
}
