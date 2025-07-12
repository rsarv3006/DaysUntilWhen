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

struct HolidayToggleListView: View {
    @StateObject private var viewModel = HolidayToggleViewModel()
    @EnvironmentObject() private var storekitStore: StorekitStore
    
    var body: some View {
            VStack(spacing: 0) {
                ZStack {
                    ScrollView {
                        VStack(spacing: 20) {
                            // Header Section
                            VStack(spacing: 8) {
                                HStack {
                                    Image(systemName: "calendar.badge.checkmark")
                                        .foregroundColor(.blue)
                                        .font(.system(size: 20, weight: .medium))
                                    Text("Holiday Notifications")
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.primary)
                                    Spacer()
                                }
                                
                                Text("Choose which holidays you'd like to track")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 16)
                            
                            // Error Message
                            if let errorMessage = viewModel.errorMessage {
                                HStack {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .foregroundColor(.red)
                                    Text(errorMessage)
                                        .font(.body)
                                        .foregroundColor(.red)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.red.opacity(0.1))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color.red.opacity(0.3), lineWidth: 1)
                                        )
                                )
                                .padding(.horizontal, 20)
                            }
                            
                            // Holiday List
                            LazyVStack(spacing: 12) {
                                ForEach($viewModel.userEnabledHolidayEntities) { $holiday in
                                    if let holidayDisplayName = viewModel.holidayDisplayValuesByVariant[holiday.holidayVariant] {
                                        HolidayToggleRow(
                                            holiday: $holiday,
                                            displayName: holidayDisplayName,
                                            viewModel: viewModel
                                        )
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 200)
                        }
                    }
                    
                    // Sticky Save Button
                    if viewModel.hasChanges {
                        VStack(spacing: 0) {
                            Spacer()
                            
                            Divider()
                            
                            Button {
                                Task {
                                    await viewModel.saveChanges()
                                }
                            } label: {
                                HStack {
                                    if viewModel.isSaving {
                                        ProgressView()
                                            .scaleEffect(0.8)
                                            .tint(.white)
                                    } else {
                                        Image(systemName: "checkmark.circle.fill")
                                            .font(.system(size: 16, weight: .medium))
                                    }
                                    Text(viewModel.isSaving ? "Saving..." : "Save Changes")
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.8)]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .shadow(color: Color.blue.opacity(0.3), radius: 8, x: 0, y: 4)
                            }
                            .disabled(viewModel.isSaving)
                            .buttonStyle(PlainButtonStyle())
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                            .background(Color(.systemBackground))
                        }
                    }
                    
                    if !storekitStore.hasPurchasedUnlockAdvancedHolidayAlerts {
                        VStack {
                            Spacer()
                            VStack(spacing: 20) {
                                Image(systemName: "lock.fill")
                                    .font(.system(size: 50))
                                    .foregroundColor(.indigo)
                                    .padding(.top, 10)
                                
                                Text("Premium Feature")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.primary)
                                
                                Text("To adjust the holidays that show in the widget please purchase the unlock feature from the settings screen.")
                                    .font(.body)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.secondary)
                                    .padding(.horizontal, 20)
                            }
                            .padding(30)
                            .background(
                                // Multiple layer background for depth
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(.regularMaterial) // Blur material
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                    )
                            )
                            .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
                            .scaleEffect(1.0) // Can animate this for entrance
                            .padding(.horizontal, 40)
                            
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(
                            Color.black.opacity(0.7)
                                .background(.ultraThinMaterial)
                                .ignoresSafeArea()
                        )
                    }
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Holidays")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel.loadHolidays()
            }
    }
}

struct HolidayToggleRow: View {
    @Binding var holiday: GRDBUserEnabledHolidays
    let displayName: String
    let viewModel: HolidayToggleViewModel
    
    // Get icon from database - you'll need to add this to your ViewModel
    private var holidayIcon: String {
        viewModel.getHolidayIcon(for: holiday.holidayVariant)
    }
    
    // Get color from text options - you'll need to add this to your ViewModel
    private var holidayColor: Color {
        viewModel.getHolidayColor(for: holiday.holidayVariant)
    }
    
    var body: some View {
        HStack(spacing: 16) {
            // Holiday Icon
            ZStack {
                Circle()
                    .fill(holidayColor.opacity(0.15))
                    .frame(width: 44, height: 44)
                
                Image(systemName: holidayIcon)
                    .foregroundColor(holidayColor)
                    .font(.system(size: 18, weight: .medium))
            }
            
            // Holiday Name
            VStack(alignment: .leading, spacing: 2) {
                Text(displayName)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
            }
            
            Spacer()
            
            // Custom Toggle
            CustomToggle(isOn: $holiday.isEnabled, color: holidayColor)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(holiday.isEnabled ? holidayColor.opacity(0.3) : Color(.systemGray5), lineWidth: 1)
        )
        .scaleEffect(holiday.isEnabled ? 1.0 : 0.98)
        .animation(.easeInOut(duration: 0.2), value: holiday.isEnabled)
    }
}

struct CustomToggle: View {
    @Binding var isOn: Bool
    let color: Color
    
    var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.2)) {
                isOn.toggle()
            }
        }) {
            ZStack {
                // Background
                RoundedRectangle(cornerRadius: 16)
                    .fill(isOn ? color : Color(.systemGray4))
                    .frame(width: 50, height: 30)
                
                // Toggle Circle
                Circle()
                    .fill(Color.white)
                    .frame(width: 26, height: 26)
                    .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
                    .offset(x: isOn ? 10 : -10)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}
