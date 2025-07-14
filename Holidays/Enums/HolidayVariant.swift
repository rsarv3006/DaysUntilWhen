import Foundation
import GRDB

public enum HolidayVariant: String, CaseIterable, Codable, DatabaseValueConvertible {
    case christmas
    case newYears
    case valentines
    case easter
    case mothersDay
    
    case halloween
    case thanksgiving
    
    case fourthOfJuly
    case fathersDay
    
//    case memorialDay
//    case veteransDay
    
    case texasIndependenceDay
}
