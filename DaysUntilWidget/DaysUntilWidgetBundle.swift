//
//  DaysUntilWidgetBundle.swift
//  DaysUntilWidget
//
//  Created by Robert J. Sarvis Jr on 11/17/23.
//

import WidgetKit
import SwiftUI

@main
struct DaysUntilWidgetBundle: WidgetBundle {
    var body: some Widget {
        DaysUntilWidget()
        DaysUntilWidgetLiveActivity()
    }
}
