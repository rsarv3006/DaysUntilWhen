import Foundation
import GRDB
import SwiftUI
import WidgetKit

struct HolidayToggleListView: View {
    @StateObject private var viewModel = HolidayToggleViewModel()
    @EnvironmentObject() private var storekitStore: StorekitStore
    
    var body: some View {
            VStack(spacing: 0) {
                ZStack {
                    ScrollView {
                        VStack(spacing: 20) {
                            PageHeader(
                                imageName: "calendar.badge.checkmark",
                                title: "Holiday Notifications",
                                subtitle: "Create a custom holiday you'd like to track"
                            )
                            
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
                                    if let holidayDisplayName = viewModel.holidayDisplayValuesByVariant[holiday.holidayVariant.rawValue] {
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
                    
                    PremiumFeatureOverlayView(message: "To adjust the holidays that show in the widget please purchase the unlock feature from the settings screen.")
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




