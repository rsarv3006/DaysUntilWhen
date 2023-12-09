//
//  ContentView.swift
//  DaysUntil
//
//  Created by Robert J. Sarvis Jr on 11/14/23.
//

import SwiftUI
import WidgetKit
import SwiftData

struct ContentView: View {
    var body: some View {
        WidgetPreviewView()
    }
}

#Preview {
    ContentView()
        .holidaysDataContainer()
}
