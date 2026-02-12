import SwiftUI
import UIKit
import WidgetKit
import GRDB

public struct CustomDateScreen: View {
    @EnvironmentObject() private var storekitStore: StorekitStore
    
    @State private var holidayName: String = ""
    @State private var selectedMonth: Int = Calendar.current.component(.month, from: Date())
    @State private var selectedDay: Int = Calendar.current.component(.day, from: Date())
    
    @State private var selectedBackgroundOptionId: String = "GenericWhite"
    @State private var selectedTextOptionId: String = "GenericBlack"
    @State private var showSavedBanner: Bool = false
    
    @Environment(\.dismiss) private var dismiss
    @State private var isSaving = false
    @State private var errorMessage: String? = nil
    
    @State private var backgroundOptions: [GRDBBackgroundOption] = []
    @State private var textOptions: [GRDBTextOption] = []
    
    private let months = Calendar.current.monthSymbols
    
    private var backgroundChoices: [(id: String, name: String)] {
        backgroundOptions.map { ($0.id, $0.id) }
    }
    
    private var textChoices: [(id: String, name: String)] {
        textOptions.map { ($0.id, $0.id) }
    }
    
    private var daysInSelectedMonth: [Int] {
        let calendar = Calendar.current
        var comps = DateComponents()
        comps.year = calendar.component(.year, from: Date())
        comps.month = selectedMonth
        let date = calendar.date(from: comps) ?? Date()
        let range = calendar.range(of: .day, in: .month, for: date) ?? 1..<29
        return Array(range)
    }
    
    private var isErrorPresented: Binding<Bool> {
        Binding<Bool>(
            get: { errorMessage != nil },
            set: { newValue in if !newValue { errorMessage = nil } }
        )
    }
    
    private var saveButtonGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.8)]),
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    private func loadOptions() async {
        do {
            let background = try await AppDatabase.shared.getAllBackgroundOptions()
            let text = try await AppDatabase.shared.getAllTextOptions()
            await MainActor.run {
                backgroundOptions = background
                textOptions = text
                if let first = background.first {
                    selectedBackgroundOptionId = first.id
                }
                if let first = text.first {
                    selectedTextOptionId = first.id
                }
            }
        } catch {
            print("Failed to load options: \(error)")
        }
    }
    
    public init() {}
    
    public var body: some View {
        VStack(spacing: 0) {
            ZStack {
                ScrollView {
                    VStack(spacing: 20) {
                        CustomDateHeader()
                        
                        CustomDateForm(holidayName: $holidayName, selectedMonth: $selectedMonth, selectedDay: $selectedDay, months: months, daysInSelectedMonth: daysInSelectedMonth, backgroundChoices: backgroundChoices, textChoices: textChoices, selectedBackgroundOptionId: $selectedBackgroundOptionId, selectedTextOptionId: $selectedTextOptionId)
                    }
                    .padding(.bottom, 100)
                }
                .task {
                    await loadOptions()
                }
                
                VStack {
                    if showSavedBanner {
                        HStack(spacing: 8) {
                            Image(systemName: "checkmark.circle.fill").foregroundColor(.white)
                            Text("Saved!").foregroundColor(.white).font(.headline)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(Color.green.opacity(0.9))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .padding(.top, 12)
                    }
                    Spacer()
                }
                .animation(.spring(response: 0.35, dampingFraction: 0.9), value: showSavedBanner)
                
                PremiumFeatureOverlayView(message: "To create and track custom dates, please purchase the unlock feature from the settings screen.")
            }
            
            // Sticky Save Button
            VStack(spacing: 0) {
                Divider()
                Button {
                    Task {
                        isSaving = true
                        errorMessage = nil
                        guard !holidayName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                            errorMessage = "Please enter a name for your holiday."
                            isSaving = false
                            return
                        }
                        let calendar = Calendar.current
                        var comps = DateComponents()
                        comps.year = calendar.component(.year, from: Date())
                        comps.month = selectedMonth
                        comps.day = selectedDay
                        guard let date = calendar.date(from: comps) else {
                            errorMessage = "Unable to create date."
                            isSaving = false
                            return
                        }
                        
                        let backgroundOptionId = selectedBackgroundOptionId
                        let textOptionId = selectedTextOptionId
                        
                        let holiday = HolidayCreation.createCustomHolidayModel(
                            id: date.timeIntervalSince1970,
                            name: holidayName.trimmingCharacters(in: .whitespacesAndNewlines),
                            description: "A custom holiday added by you!",
                            greeting: "Happy \(holidayName)!",
                            icon: "calendar.circle.fill"
                        )
                        do {
                            try await AppDatabase.shared.dbWriter.write { db in
                                try holiday.insert(db)
                                // Persist display options for this holiday's variant (Option A)
                                var displayOptions = try GRDBHolidayDisplayOptions.fetchOne(db, key: holiday.variant) ?? GRDBHolidayDisplayOptions.new(id: holiday.variant)
                                displayOptions.updateDisplayOptions(backgroundOptionId: backgroundOptionId, textOptionId: textOptionId)
                                try displayOptions.save(db)
                            }
                            let generator = UINotificationFeedbackGenerator()
                            generator.notificationOccurred(.success)
                            WidgetCenter.shared.reloadAllTimelines()
                            showSavedBanner = true
                            try await Task.sleep(nanoseconds: 1_000_000_000)
                            dismiss()
                        } catch {
                            errorMessage = "Failed to save your holiday: \(error.localizedDescription)"
                        }
                        isSaving = false
                    }
                } label: {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 16, weight: .medium))
                        Text("Save Custom Date")
                            .font(.headline)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(saveButtonGradient)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(color: Color.blue.opacity(0.3), radius: 8, x: 0, y: 4)
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .background(Color(.systemBackground))
                .disabled(isSaving)
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Add Custom Date")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Error", isPresented: isErrorPresented) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage ?? "Unknown error.")
        }
    }
}

private struct CustomDateHeader: View {
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "calendar.badge.plus")
                .font(.system(size: 40))
                .foregroundColor(.accentColor)
            Text("Add Custom Date")
                .font(.title3).bold()
            Text("Create a custom day to count down to.")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .accessibilityElement(children: .combine)
    }
}

private struct CustomDateForm: View {
    @Binding var holidayName: String
    @Binding var selectedMonth: Int
    @Binding var selectedDay: Int
    let months: [String]
    let daysInSelectedMonth: [Int]
    let backgroundChoices: [(id: String, name: String)]
    let textChoices: [(id: String, name: String)]
    @Binding var selectedBackgroundOptionId: String
    @Binding var selectedTextOptionId: String

    var body: some View {
        VStack(spacing: 24) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Holiday Name")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                TextField("Enter holiday name", text: $holidayName)
                    .textFieldStyle(.roundedBorder)
            }
            VStack(alignment: .leading, spacing: 8) {
                Text("Month")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Picker("Month", selection: $selectedMonth) {
                    ForEach(1...12, id: \.self) { idx in
                        Text(months[idx - 1]).tag(idx)
                    }
                }
                .pickerStyle(.menu)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            VStack(alignment: .leading, spacing: 8) {
                Text("Day")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Picker("Day", selection: $selectedDay) {
                    ForEach(daysInSelectedMonth, id: \.self) { day in
                        Text("\(day)").tag(day)
                    }
                }
                .pickerStyle(.menu)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            VStack(alignment: .leading, spacing: 8) {
                Text("Background")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Picker("Background", selection: $selectedBackgroundOptionId) {
                    ForEach(backgroundChoices, id: \.id) { item in
                        Text(item.name).tag(item.id)
                    }
                }
                .pickerStyle(.menu)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            VStack(alignment: .leading, spacing: 8) {
                Text("Text Color")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Picker("Text Color", selection: $selectedTextOptionId) {
                    ForEach(textChoices, id: \.id) { item in
                        Text(item.name).tag(item.id)
                    }
                }
                .pickerStyle(.menu)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(20)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: Color(.systemGray3).opacity(0.15), radius: 10, x: 0, y: 4)
        .padding(.horizontal, 20)
    }
}
