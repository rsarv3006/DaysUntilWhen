enum HolidayLoadingError: Error {
    case invalidChristmasDate
    case invalidNewYearDate
    case invalidValentinesDate
    case invalidEasterDate
    case failedToLoadBackgroundOptions
    case failedToLoadTextOptions
    case failedToLoadDisplayOptions
    case attemptedToLoadDisplayOptionsBeforeDependencies
}
