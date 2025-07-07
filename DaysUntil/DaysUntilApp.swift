import SwiftUI

@main
struct DaysUntilApp: App {
    @StateObject var storekitStore = StorekitStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.appDatabase, .shared)
                .checkAppVersion()
                .environmentObject(storekitStore)
                .onAppear {
                    Task {
                        await storekitStore.updateCustomerProductStatus()
                    }
                }
        }
    }
}

private struct AppDatabaseKey: EnvironmentKey {
    static var defaultValue: AppDatabase { .shared }
}

extension EnvironmentValues {
    var appDatabase: AppDatabase {
        get { self[AppDatabaseKey.self] }
        set { self[AppDatabaseKey.self] = newValue }
    }
}
