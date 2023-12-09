//
//  TextOption.swift
//  SharedUI
//
//  Created by Robert J. Sarvis Jr on 11/20/23.
//

import SwiftUI
import SwiftData

enum TextOptionId: String, Codable {
    case ChristmasRed
    case ChristmasWhite
    case ChristmasGreen
}

@Model
class TextOption: Identifiable {
    let id: TextOptionId
    let optionName: String
    let holidayFilter: [HolidayVariant]
    
    @Transient
    var color: Color? {
        return Color(id.rawValue)
    }
    
    init(id: TextOptionId, optionName: String = "", holidayFilter: [HolidayVariant] = []) {
        self.id = id
        self.optionName = optionName.isEmpty ? id.rawValue : optionName
        self.holidayFilter = holidayFilter
    }
}

extension TextOption: Hashable {
    static func == (lhs: TextOption, rhs: TextOption) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
