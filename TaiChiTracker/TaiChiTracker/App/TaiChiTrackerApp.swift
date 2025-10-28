//
//  TaiChiTrackerApp.swift
//  TaiChiTracker
//
//  Main app entry point
//

import SwiftUI

@main
struct TaiChiTrackerApp: App {
    @StateObject private var progressTracker = ProgressTracker()
    @StateObject private var sessionManager = SessionManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(progressTracker)
                .environmentObject(sessionManager)
        }
    }
}
