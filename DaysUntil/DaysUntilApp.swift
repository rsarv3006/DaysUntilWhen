//
//  DaysUntilApp.swift
//  DaysUntil
//
//  Created by Robert J. Sarvis Jr on 11/14/23.
//

import SwiftUI

@main
struct DaysUntilApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .holidaysDataContainer(inMemory: false)
        }
    }
}
