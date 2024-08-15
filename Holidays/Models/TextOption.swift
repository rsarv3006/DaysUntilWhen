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
    case GenericBlack
    case GenericWhite
    case GenericGold
    case ValentinesRed
    case ValentinesPink
    case EasterPurple
    case EasterOrange
    case EasterGreen
    case MothersDayGray
    case MothersDayYellow
    case HalloweenOrange
    case HalloweenPurple
    case HalloweenGreen
    case HalloweenBone
}

@Model
class TextOption: Identifiable {
    @Attribute(.unique) let id: String
    let optionName: String
    let holidayFilter: [HolidayVariant]
    
    @Transient
    var color: Color? {
        return Color(id)
    }
    
    init(id: String, optionName: String = "", holidayFilter: [HolidayVariant] = []) {
        self.id = id
        self.optionName = optionName.isEmpty ? id : optionName
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
