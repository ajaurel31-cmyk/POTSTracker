import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            DailyLogView()
                .tabItem {
                    Label("Log Today", systemImage: "square.and.pencil")
                }

            HistoryView()
                .tabItem {
                    Label("History", systemImage: "chart.line.uptrend.xyaxis")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
        .tint(.pink)
    }
}
