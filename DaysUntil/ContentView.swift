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
            
            CustomDateScreen()
                .tabItem {
                    Image(systemName: "calendar.badge.plus")
                    Text("Add Custom Date")
                }
            
            SettingsScreen()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
    }
}
