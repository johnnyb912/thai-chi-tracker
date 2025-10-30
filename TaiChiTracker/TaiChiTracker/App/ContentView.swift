//
//  ContentView.swift
//  TaiChiTracker
//
//  Main navigation view with tabs
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var progressTracker: ProgressTracker
    @EnvironmentObject var sessionManager: SessionManager

    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

            CalendarView()
                .tabItem {
                    Label("Schedule", systemImage: "calendar")
                }

            ProgressTrackingView()
                .tabItem {
                    Label("Progress", systemImage: "chart.line.uptrend.xyaxis")
                }

            LibraryView()
                .tabItem {
                    Label("Library", systemImage: "play.rectangle.fill")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
        .accentColor(.blue)
    }
}

#Preview {
    ContentView()
        .environmentObject(ProgressTracker())
        .environmentObject(SessionManager())
}
