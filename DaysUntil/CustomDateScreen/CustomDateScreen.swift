import SwiftUI

struct CustomDateScreen: View {
    @EnvironmentObject() private var storekitStore: StorekitStore
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                ScrollView {
                    VStack(spacing: 20) {
                        PageHeader(
                            imageName: "calendar.badge.plus",
                            title: "Add Custom Date",
                            subtitle: "Choose which holidays you'd like to track"
                        )
                        
                        LazyVStack(spacing: 12) {
                            Text("Hello")
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 200)
                    }
                }
                
                PremiumFeatureOverlayView(message:"To create custom items please purchase the unlock feature from the settings screen.")
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Add Custom Date")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {}
    }
}

