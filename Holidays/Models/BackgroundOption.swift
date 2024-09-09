import SwiftUI
import SwiftData

enum BackgroundOptionId: String, Codable {
    case ChristmasBackground1
    case ChristmasRed
    case ChristmasWhite
    case ChristmasGreen
    case GenericBlack
    case GenericWhite
    case GenericGold
    case NewYearsBackground1
    case ValentinesBackground1
    case ValentinesRed
    case ValentinesPink
    case EasterBackground1
    case EasterPurple
    case EasterOrange
    case EasterGreen
    case MothersDayBackground1
    case MothersDayGray
    case MothersDayYellow
    case HalloweenOrange
    case HalloweenPurple
    case HalloweenGreen
    case HalloweenBone
    case HalloweenBackground1
    case ThanksgivingBackground1
    case ThanksgivingSpicedPumpkin
    case ThanksgivingGreen
    case ThanksgivingWhite
}

enum BackgroundOptionType: String, Codable {
    case image
    case color
}

@Model
class BackgroundOption: Identifiable {
    @Attribute(.unique) let id: String
    let type: BackgroundOptionType
    let optionName: String
    let holidayFilter: [HolidayVariant]
   
    @Transient
    var image: Image? {
        guard type == .image else { return nil }
        return Image(id)
    }
    
    @Transient
    var color: Color? {
        guard type == .color else { return nil }
        return Color(id)
    }
    
    init(id: String, type: BackgroundOptionType, optionName: String = "", holidayFilter: [HolidayVariant] = []) {
        self.id = id
        self.type = type
        self.optionName = optionName.isEmpty ? id : optionName
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
