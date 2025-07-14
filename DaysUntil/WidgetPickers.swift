import SwiftUI
import GRDB
import GRDBQuery

struct WidgetPickers: View {
    @Environment(\.appDatabase) private var appDatabase
    
    @Binding var allHolidays: [GRDBHoliday]
    @Binding var backgroundOptions: [GRDBBackgroundOption]
    @Binding var textOptions: [GRDBTextOption]
    
    @Binding var selectedHoliday: GRDBHoliday
    @Binding var selectedBackground: GRDBBackgroundOption
    @Binding var selectedText: GRDBTextOption
    
    var onHolidayChangeSaved: (() -> Void)?
    
    func buildHolidayListDisplayString(_ holiday: GRDBHoliday) -> String {
        if let holidayDate = holiday.date {
            return "\(holiday.name) - \(holidayDate.year)"
        }
        return holiday.name
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Holiday Picker Section
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "calendar.badge.exclamationmark")
                        .foregroundColor(.red)
                        .font(.system(size: 16, weight: .medium))
                    Text("Holiday")
                        .font(.headline)
                        .foregroundColor(.primary)
                }
                
                Picker("Selected Holiday", selection: $selectedHoliday) {
                    ForEach(allHolidays, id: \.self) { holiday in
                        Text(buildHolidayListDisplayString(holiday))
                            .font(.body)
                            .tag(buildHolidayListDisplayString(holiday))
                    }
                }
                .pickerStyle(.menu)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemGray6))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(.systemGray4), lineWidth: 1)
                        )
                )
            }
            
            // Background Picker Section
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "photo.on.rectangle.angled")
                        .foregroundColor(.blue)
                        .font(.system(size: 16, weight: .medium))
                    Text("Background")
                        .font(.headline)
                        .foregroundColor(.primary)
                }
                
                Picker("Selected Background", selection: $selectedBackground) {
                    ForEach(backgroundOptions.filter({ option in
                        option.holidayFilter.contains(selectedHoliday.variant)
                    }), id: \.self) { background in
                        Text(background.optionName)
                            .font(.body)
                            .tag(background.optionName)
                    }
                }
                .pickerStyle(.menu)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemGray6))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(.systemGray4), lineWidth: 1)
                        )
                )
            }
            
            // Text Color Picker Section
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "textformat.alt")
                        .foregroundColor(.green)
                        .font(.system(size: 16, weight: .medium))
                    Text("Text Style")
                        .font(.headline)
                        .foregroundColor(.primary)
                }
                
                Picker("Selected Text Color", selection: $selectedText) {
                    ForEach(textOptions.filter({ option in
                        option.holidayFilter.contains(selectedHoliday.variant)
                    }), id: \.self) { text in
                        Text(text.optionName)
                            .font(.body)
                            .tag(text.optionName)
                    }
                }
                .pickerStyle(.menu)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemGray6))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(.systemGray4), lineWidth: 1)
                        )
                )
            }
            
            // Update Button
            Button(action: {
                onHolidayChangeSaved?()
            }) {
                HStack {
                    Image(systemName: "arrow.triangle.2.circlepath")
                        .font(.system(size: 16, weight: .medium))
                    Text("Update Holiday")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.blue, Color.indigo]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(color: Color.blue.opacity(0.3), radius: 8, x: 0, y: 4)
            }
            .buttonStyle(PlainButtonStyle())
            .scaleEffect(1.0)
            .animation(.easeInOut(duration: 0.1), value: false)
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        )
    }
}
