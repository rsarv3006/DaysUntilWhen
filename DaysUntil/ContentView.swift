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
            
            // Example of additional tab you might add later
            SettingsScreen()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
    }
}
