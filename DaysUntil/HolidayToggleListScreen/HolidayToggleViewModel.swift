import Foundation
import GRDB
import SwiftUI
import WidgetKit

@MainActor
class HolidayToggleViewModel: ObservableObject {
    private var appDatabase: AppDatabase
    
    @Published var holidayDisplayValuesByVariant: [HolidayVariant: String] = [:]
    @Published var holidayIconsByVariant: [HolidayVariant: String] = [:]
    @Published var textOptionsByVariant: [HolidayVariant: GRDBTextOption] = [:]
    @Published var userEnabledHolidayEntities: [GRDBUserEnabledHolidays] = []
    @Published var isSaving: Bool = false
    @Published var errorMessage: String? = nil
    
    private var originalStates: [String: Bool] = [:]
    
    public init(appDatabase: AppDatabase = .shared) {
        self.appDatabase = appDatabase
    }
    
    var hasChanges: Bool {
        userEnabledHolidayEntities.contains { holiday in
            originalStates[holiday.id] != holiday.isEnabled
        }
    }
    
    func loadHolidays() {
        do {
            try appDatabase.reader.read { db in
                let allHolidays = try appDatabase.getAllHolidays(in: db)
                for holiday in allHolidays {
                    holidayDisplayValuesByVariant[holiday.variant] = holiday.name
                    holidayIconsByVariant[holiday.variant] = holiday.icon
                }
                
                userEnabledHolidayEntities = try appDatabase.getAllUserEnableHolidayEntities(in: db)
                
                let allTextOptions = try appDatabase.getAllTextOptions(in: db)
                
                let allDisplayOptions = try appDatabase.getAllDisplayOptions(in: db)
                for option in allDisplayOptions {
                    textOptionsByVariant[option.id] = allTextOptions.first(where: { $0.id == option.textOptionId })
                }
                
                originalStates = userEnabledHolidayEntities.reduce(into: [:]) { result, holiday in
                    result[holiday.id] = holiday.isEnabled
                }
            }
        } catch {
            errorMessage = "Failed to load user enabled holidays: \(error)"
        }
    }
    
    func saveChanges() async {
        guard hasChanges else { return }
        
        isSaving = true
        defer { isSaving = false }
        
        // Get only the holidays that have changed
        let changedHolidays = userEnabledHolidayEntities.filter { holiday in
            originalStates[holiday.id] != holiday.isEnabled
        }
        
        // Save to database
        await saveHolidaysToDatabase(changedHolidays)
        
        // Update original states to match current states
        for holiday in userEnabledHolidayEntities {
            originalStates[holiday.id] = holiday.isEnabled
        }
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    private func saveHolidaysToDatabase(_ holidays: [GRDBUserEnabledHolidays]) async {
        do {
            try appDatabase.updateUserEnabledHolidays(holidays)
        } catch {
            errorMessage = "Failed to save holidays: \(error)"
        }
    }
    
    public func getHolidayIcon(for holidayVariant: HolidayVariant) -> String {
        return holidayIconsByVariant[holidayVariant] ?? "calendar"
    }
    
    public func getHolidayColor(for holidayVariant: HolidayVariant) -> Color {
        return textOptionsByVariant[holidayVariant]?.color ??
            .gray
    }
}
