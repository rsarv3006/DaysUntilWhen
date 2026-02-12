import SwiftUI
import WidgetKit
import SwiftData

struct ContentView: View {
    var body: some View {
        TabView {
            WidgetPreviewView()
                .tabItem {
                    Image(systemName: "widget.small")
                    Text("Widget")
                }
            
            HolidayToggleListView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Holidays")
                }
            
            CustomDatesListView(appDatabase: AppDatabase.shared)
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Custom Dates")
                }
            
            SettingsScreen()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
    }
}
