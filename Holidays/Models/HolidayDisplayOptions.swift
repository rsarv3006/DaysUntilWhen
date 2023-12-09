//
//  HolidayDisplayOptions.swift
//  SharedUI
//
//  Created by Robert J. Sarvis Jr on 12/1/23.
//

import Foundation
import SwiftData

@Model
class HolidayDisplayOptions {
    let id: HolidayVariant
    @Relationship var backgroundOption: BackgroundOption?
    @Relationship var textOption: TextOption?
    
    init(id: HolidayVariant) {
        self.id = id
    }
    
    func updateDisplayOptions(backgroundOption: BackgroundOption?, textOption: TextOption?) {
        self.backgroundOption = backgroundOption
        self.textOption = textOption
    }
}
