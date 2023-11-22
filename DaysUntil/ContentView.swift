//
//  ContentView.swift
//  DaysUntil
//
//  Created by Robert J. Sarvis Jr on 11/14/23.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedHoliday: Holiday = HolidaysList[0]
    @State private var selectedBackground: BackgroundOption = BackgroundOptionsList[0]
    @State private var selectedText: TextOption = TextOptionsList[0]
    
    var body: some View {
        VStack {
            Text("DaysUntilWhen")
                .font(.largeTitle)
            VStack(alignment: .leading) {
                WidgetPickers(selectedHoliday: $selectedHoliday, selectedBackground: $selectedBackground, selectedText: $selectedText)
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
                
                DaysUntilWidgetEntryView(entry: .init(date: Date(), holiday: selectedHoliday), background: selectedBackground, text: selectedText)
            }
            Spacer()
        }
    }
}

#Preview {
    ContentView()
}
