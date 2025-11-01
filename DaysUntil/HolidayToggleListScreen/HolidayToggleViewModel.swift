import Foundation
import GRDB
import SwiftUI
import WidgetKit

@MainActor
class HolidayToggleViewModel: ObservableObject {
    private var appDatabase: AppDatabase
    
    @Published var holidayDisplayValuesByVariant: [String: String] = [:]
    @Published var holidayIconsByVariant: [String: String] = [:]
    @Published var textOptionsByVariant: [String: GRDBTextOption] = [:]
    @Published var userEnabledHolidayEntities: [GRDBUserEnabledHolidays] = []
    @Published var isSaving: Bool = false
    @Published var errorMessage: String? = nil
    
    private var originalStates: [String: Bool] = [:]
    
    public init(appDatabase: AppDatabase = .shared) {
        self.appDatabase = appDatabase
    }
    
    func key(for holiday: GRDBHoliday) -> String {
        if holiday.variant == .custom {
            return "custom_\(holiday.name)_\(Int(holiday.id))"
        } else {
            return holiday.variant.rawValue
        }
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
                    let key = self.key(for: holiday)
                    holidayDisplayValuesByVariant[key] = holiday.name
                    holidayIconsByVariant[key] = holiday.icon
                }
                
                userEnabledHolidayEntities = try appDatabase.getAllUserEnableHolidayEntities(in: db)
                
                let allTextOptions = try appDatabase.getAllTextOptions(in: db)
                
                let allDisplayOptions = try appDatabase.getAllDisplayOptions(in: db)
                for option in allDisplayOptions {
                    textOptionsByVariant[option.id.rawValue] = allTextOptions.first(where: { $0.id == option.textOptionId })
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
    
    public func getHolidayIcon(forKey key: String) -> String {
        return holidayIconsByVariant[key] ?? "calendar"
    }
    
    public func getHolidayColor(forKey key: String) -> Color {
        return textOptionsByVariant[key]?.color ??
            .gray
    }
}
