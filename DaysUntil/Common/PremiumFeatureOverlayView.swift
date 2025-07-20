import SwiftUI

struct PremiumFeatureOverlayView: View {
    @EnvironmentObject private var storekitStore: StorekitStore
    let message: String
    
    var body: some View {
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
                    
                    Text(message)
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

