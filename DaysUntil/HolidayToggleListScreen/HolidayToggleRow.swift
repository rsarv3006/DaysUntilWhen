import Foundation
import GRDB
import SwiftUI
import WidgetKit

struct HolidayToggleRow: View {
    @Binding var holiday: GRDBUserEnabledHolidays
    let displayName: String
    let viewModel: HolidayToggleViewModel
    
    private var holidayIcon: String {
        viewModel.getHolidayIcon(forKey: holiday.holidayVariant.rawValue)
    }
    
    private var holidayColor: Color {
        viewModel.getHolidayColor(forKey: holiday.holidayVariant.rawValue)
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
            
            VStack(alignment: .leading, spacing: 2) {
                Text(displayName)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
            }
            
            Spacer()
            
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
