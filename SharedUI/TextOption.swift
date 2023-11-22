//
//  TextOption.swift
//  SharedUI
//
//  Created by Robert J. Sarvis Jr on 11/20/23.
//

import SwiftUI

enum TextOptionId: String {
    case ChristmasRed
    case ChristmasWhite
    case ChristmasGreen
}
struct TextOption: Identifiable {
    let id: TextOptionId
    let optionName: String
    
    var color: Color? {
        return Color(id.rawValue)
    }
    
    init(id: TextOptionId, optionName: String = "") {
        self.id = id
        self.optionName = optionName.isEmpty ? id.rawValue : optionName
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

let TextOptionsList = [
    TextOption(id: .ChristmasRed),
    TextOption(id: .ChristmasWhite),
    TextOption(id: .ChristmasGreen)
]
