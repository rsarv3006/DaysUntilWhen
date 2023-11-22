//
//  BackgroundOption.swift
//  SharedUI
//
//  Created by Robert J. Sarvis Jr on 11/19/23.
//

import SwiftUI

enum BackgroundOptionId: String {
    case ChristmasBackground1
    case ChristmasRed
    case ChristmasWhite
    case ChristmasGreen
}

enum BackgroundOptionType {
    case image
    case color
}

struct BackgroundOption: Identifiable {
    let id: BackgroundOptionId
    let type: BackgroundOptionType
    let optionName: String
    
    var image: Image? {
        guard type == .image else { return nil }
        return Image(id.rawValue)
    }
    
    var color: Color? {
        guard type == .color else { return nil }
        return Color(id.rawValue)
    }
    
    init(id: BackgroundOptionId, type: BackgroundOptionType, optionName: String = "") {
        self.id = id
        self.type = type
        self.optionName = optionName.isEmpty ? id.rawValue : optionName
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

let BackgroundOptionsList = [
    BackgroundOption(id: .ChristmasBackground1, type: .image),
    BackgroundOption(id: .ChristmasRed, type: .color),
    BackgroundOption(id: .ChristmasWhite, type: .color),
    BackgroundOption(id: .ChristmasGreen, type: .color)
]
