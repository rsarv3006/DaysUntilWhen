import SwiftUI
import StoreKit
import GRDB
import GRDBQuery

struct SettingsScreen: View {
    @Environment(\.appDatabase) private var appDatabase
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject() private var storekitStore: StorekitStore
    @StateObject private var viewModel = SettingsViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Purchases Section
                SettingsSection(
                    title: "Purchases",
                    icon: "creditcard.fill",
                    iconColor: .green
                ) {
                    VStack(spacing: 16) {
                        if storekitStore.hasPurchasedUnlockAdvancedHolidayAlerts {
                            SettingsInfoRow(
                                title: "Advanced Unlock",
                                subtitle: "Thank you for your support!",
                                icon: "checkmark.circle.fill",
                                iconColor: .green
                            )
                        } else {
                            SettingsPurchaseRow(
                                title: "Purchase Advanced Unlock",
                                subtitle: "Unlock premium features and customization",
                                icon: "star.circle.fill",
                                iconColor: .yellow,
                                price: "$1.99",
                                isLoading: viewModel.isLoading
                            ) {
                                Task {
                                    viewModel.isLoading = true
                                    if let product = storekitStore.unlockAdvancedHolidayAlertsProduct {
                                        await buy(product: product)
                                    } else {
                                        viewModel.showAlert(title: "Uh Oh", message: "Unable to complete purchase. Please try again later.")
                                    }
                                    viewModel.isLoading = false
                                }
                            }
                        }
                        
                        SettingsActionRow(
                            title: "Restore Purchases",
                            subtitle: "Restore previous purchases",
                            icon: "arrow.clockwise.circle.fill",
                            iconColor: .blue,
                            action: viewModel.restorePurchases
                        )
                    }
                    .background(Color(UIColor.systemBackground))
                }
                
                // About Section
                SettingsSection(
                    title: "About",
                    icon: "info.circle",
                    iconColor: .gray
                ) {
                    VStack(spacing: 16) {
                        SettingsActionRow(
                            title: "End User License Agreement",
                            subtitle: "Terms and conditions",
                            icon: "doc.text.fill",
                            iconColor: .orange,
                            action: viewModel.openEULA
                        )
                        
                        SettingsActionRow(
                            title: "Privacy Policy",
                            subtitle: "How we protect your data",
                            icon: "hand.raised.fill",
                            iconColor: .mint,
                            action: viewModel.openPrivacyPolicy
                        )
                    }
                    .background(Color(UIColor.systemBackground))
                }
                
                // App Controls Section
                SettingsSection(
                    title: "App Controls",
                    icon: "gear.badge.xmark",
                    iconColor: .red
                ) {
                    VStack(spacing: 16) {
                        SettingsDestructiveActionRow(
                            title: "Reset App",
                            subtitle: "Clear all data and start fresh",
                            icon: "trash.circle.fill",
                            iconColor: .red,
                            action: viewModel.resetApp
                        )
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") {
                    dismiss()
                }
                .fontWeight(.semibold)
            }
        }
        .alert(viewModel.alertTitle, isPresented: $viewModel.showingAlert) {
            if viewModel.alertTitle == "Reset App" {
                Button("Cancel", role: .cancel) { }
                Button("Reset", role: .destructive) {
                    do {
                        try appDatabase.reset()
                    } catch {
                        viewModel.showAlert(title: "Problem resetting app", message: "There was a problem resetting your app. Please try again later.")
                    }
                    viewModel.confirmReset()
                }
            } else {
                Button("OK") {
                    viewModel.showingAlert = false
                }
            }
        } message: {
            Text(viewModel.alertMessage)
        }
    }
    
    func buy(product: Product) async {
        do {
            if try await storekitStore.purchase(product) != nil {
                withAnimation {
                    storekitStore.hasPurchasedUnlockAdvancedHolidayAlerts = true
                }
            }
        }  catch {
            print("Failed purchase for \(String(describing: product.id)): \(error)")
            viewModel.showAlert(title: "Uh Oh", message: "Unable to complete purchase. Please try again later.")
        }
    }
}


