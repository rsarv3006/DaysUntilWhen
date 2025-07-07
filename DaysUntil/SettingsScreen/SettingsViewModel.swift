import SwiftUI
import StoreKit

import Foundation

@MainActor
class SettingsViewModel: ObservableObject {
    @Published var showingAlert = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    @Published var isLoading: Bool = false
    
    init() {
    }
    
    // MARK: - Purchase Actions
    
    func restorePurchases() {
        Task {
            do {
                isLoading = true
                try await AppStore.sync()
                
                self.isLoading = false
                
                self.showAlert(
                    title: "Restore Complete",
                    message: "Your purchases have been restored."
                )
                
            } catch {
                self.showAlert(title: "Uh Oh!", message: "Failed to restore purchases, please try again.")
            }
            
        }
    }
    
    // MARK: - About Actions
    
    func openEULA() {
        if let url = URL(string: "https://rjsappdev.wixsite.com/daysuntilwhen/eula") {
            UIApplication.shared.open(url)
        }
    }
    
    func openPrivacyPolicy() {
        if let url = URL(string: "https://rjsappdev.wixsite.com/daysuntilwhen/privacy-policy") {
            UIApplication.shared.open(url)
        }
    }
    
    // MARK: - App Controls Actions
    
    func resetApp() {
        showAlert(
            title: "Reset App",
            message: "Are you sure you want to reset all data? This action cannot be undone."
        )
    }
    
    func confirmReset() {
        // TODO: Implement actual app reset
        // This would typically involve:
        // - Clearing UserDefaults
        // - Clearing Core Data/GRDB
        // - Resetting to default state
        
        showAlert(
            title: "Reset Complete",
            message: "All app data has been reset."
        )
    }
    
    // MARK: - Helper Methods
    public func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showingAlert = true
    }
}
