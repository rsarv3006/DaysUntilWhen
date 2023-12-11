//
//  BackgroundOption.swift
//  SharedUI
//
//  Created by Robert J. Sarvis Jr on 11/19/23.
//

import SwiftUI
import SwiftData

enum BackgroundOptionId: String, Codable {
    case ChristmasBackground1
    case ChristmasRed
    case ChristmasWhite
    case ChristmasGreen
    case GenericBlack
    case GenericWhite
}

enum BackgroundOptionType: String, Codable {
    case image
    case color
}

@Model
class BackgroundOption: Identifiable {
    let id: BackgroundOptionId
    let type: BackgroundOptionType
    let optionName: String
    let holidayFilter: [HolidayVariant]
   
    @Transient
    var image: Image? {
        guard type == .image else { return nil }
        return Image(id.rawValue)
    }
    
    @Transient
    var color: Color? {
        guard type == .color else { return nil }
        return Color(id.rawValue)
    }
    
    init(id: BackgroundOptionId, type: BackgroundOptionType, optionName: String = "", holidayFilter: [HolidayVariant] = []) {
        self.id = id
        self.type = type
        self.optionName = optionName.isEmpty ? id.rawValue : optionName
        self.holidayFilter = holidayFilter
    }
}

extension BackgroundOption: Hashable {
    static func == (lhs: BackgroundOption, rhs: BackgroundOption) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
