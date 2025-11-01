import SwiftUI

struct CustomDateScreen: View {
    @EnvironmentObject() private var storekitStore: StorekitStore
    
    @State private var holidayName: String = ""
    @State private var selectedMonth: Int = Calendar.current.component(.month, from: Date())
    @State private var selectedDay: Int = Calendar.current.component(.day, from: Date())
    
    @Environment(\.appDatabase) private var appDatabase
    @Environment(\.dismiss) private var dismiss
    @State private var isSaving = false
    @State private var errorMessage: String? = nil
    
    private let months = Calendar.current.monthSymbols
    
    private var daysInSelectedMonth: [Int] {
        let calendar = Calendar.current
        var comps = DateComponents()
        comps.year = calendar.component(.year, from: Date())
        comps.month = selectedMonth
        let date = calendar.date(from: comps) ?? Date()
        let range = calendar.range(of: .day, in: .month, for: date) ?? 1..<29
        return Array(range)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                ScrollView {
                    VStack(spacing: 20) {
                        PageHeader(
                            imageName: "calendar.badge.plus",
                            title: "Add Custom Date",
                            subtitle: "Create a custom day to count down to."
                        )
                        
                        VStack(spacing: 24) {
                            // Name field
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Holiday Name")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                TextField("Enter holiday name", text: $holidayName)
                                    .textFieldStyle(.roundedBorder)
                            }
                            // Month picker
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
                            // Day picker
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
                        }
                        .padding(20)
                        .background(Color(.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .shadow(color: Color(.systemGray3).opacity(0.15), radius: 10, x: 0, y: 4)
                        .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 100)
                }
                
                // Premium overlay
                PremiumFeatureOverlayView(message:"To create custom items please purchase the unlock feature from the settings screen.")
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
                        let holiday = HolidayCreation.createCustomHolidayModel(
                            id: date.timeIntervalSince1970,
                            name: holidayName.trimmingCharacters(in: .whitespacesAndNewlines),
                            description: "A custom holiday added by you!",
                            greeting: "Happy \(holidayName)!",
                            icon: "calendar.circle.fill"
                        )
                        do {
                            try await appDatabase.dbWriter.write { db in
                                try holiday.insert(db)
                            }
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
                    .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.8)]), startPoint: .leading, endPoint: .trailing))
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
        .alert("Error", isPresented: Binding(get: { errorMessage != nil }, set: { _ in errorMessage = nil })) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage ?? "Unknown error.")
        }
    }
}

