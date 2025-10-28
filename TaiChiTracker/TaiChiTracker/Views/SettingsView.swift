//
//  SettingsView.swift
//  TaiChiTracker
//
//  Settings and profile view
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var progressTracker: ProgressTracker
    @State private var showingResetAlert = false
    @State private var showingAbout = false

    // User profile data
    @AppStorage("userName") private var userName: String = ""
    @AppStorage("userAge") private var userAge: String = "43"
    @AppStorage("userHeight") private var userHeight: String = "5'11\""
    @AppStorage("userWeight") private var userWeight: String = "188"
    @AppStorage("notificationsEnabled") private var notificationsEnabled: Bool = true
    @AppStorage("reminderTime") private var reminderTime: Date = Date()

    var body: some View {
        NavigationView {
            Form {
                // Profile section
                Section(header: Text("Profile")) {
                    HStack {
                        Text("Name")
                        Spacer()
                        TextField("Your name", text: $userName)
                            .multilineTextAlignment(.trailing)
                    }

                    HStack {
                        Text("Age")
                        Spacer()
                        TextField("Age", text: $userAge)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 80)
                    }

                    HStack {
                        Text("Height")
                        Spacer()
                        TextField("Height", text: $userHeight)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 80)
                    }

                    HStack {
                        Text("Weight")
                        Spacer()
                        TextField("lbs", text: $userWeight)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 80)
                    }
                }

                // Training section
                Section(header: Text("Training")) {
                    HStack {
                        Text("Current Week")
                        Spacer()
                        Text("\(progressTracker.currentWeek) of 12")
                            .foregroundColor(.secondary)
                    }

                    HStack {
                        Text("Start Date")
                        Spacer()
                        Text(formatDate(progressTracker.startDate))
                            .foregroundColor(.secondary)
                    }

                    HStack {
                        Text("Training Days")
                        Spacer()
                        Text("Mon, Wed, Fri")
                            .foregroundColor(.secondary)
                    }
                }

                // Notifications section
                Section(header: Text("Notifications")) {
                    Toggle("Practice Reminders", isOn: $notificationsEnabled)

                    if notificationsEnabled {
                        DatePicker("Reminder Time", selection: $reminderTime, displayedComponents: .hourAndMinute)
                    }
                }

                // App info section
                Section(header: Text("About")) {
                    Button(action: {
                        showingAbout = true
                    }) {
                        HStack {
                            Text("About Tai Chi Tracker")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }

                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                }

                // Data management
                Section(header: Text("Data")) {
                    Button(role: .destructive, action: {
                        showingResetAlert = true
                    }) {
                        Text("Reset All Data")
                    }
                }
            }
            .navigationTitle("Settings")
        }
        .alert("Reset All Data", isPresented: $showingResetAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Reset", role: .destructive) {
                resetAllData()
            }
        } message: {
            Text("This will delete all your progress, sessions, and metrics. This action cannot be undone.")
        }
        .sheet(isPresented: $showingAbout) {
            AboutView()
        }
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    private func resetAllData() {
        // Clear UserDefaults
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()

        // Reset tracker (will be reinitialized on next launch)
        progressTracker.completedSessions = []
        progressTracker.progressMetrics = []
        progressTracker.currentWeek = 1
        progressTracker.startDate = Date()
    }
}

struct AboutView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // App icon
                    Image(systemName: "figure.tai.chi")
                        .font(.system(size: 80))
                        .foregroundColor(.blue)
                        .padding()

                    VStack(spacing: 8) {
                        Text("Tai Chi Tracker")
                            .font(.title)
                            .fontWeight(.bold)

                        Text("Your Personal Tai Chi Journey")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }

                    Divider()
                        .padding(.horizontal)

                    // Features
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Features")
                            .font(.headline)
                            .padding(.horizontal)

                        FeatureRow(
                            icon: "calendar",
                            title: "12-Week Program",
                            description: "Structured beginner-friendly progression"
                        )

                        FeatureRow(
                            icon: "timer",
                            title: "Guided Sessions",
                            description: "30-minute sessions with built-in timer"
                        )

                        FeatureRow(
                            icon: "chart.line.uptrend.xyaxis",
                            title: "Progress Tracking",
                            description: "Track your metrics and improvements"
                        )

                        FeatureRow(
                            icon: "play.rectangle",
                            title: "Video Library",
                            description: "Learn proper technique from experts"
                        )
                    }

                    Divider()
                        .padding(.horizontal)

                    // Plan details
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Training Plan")
                            .font(.headline)
                            .padding(.horizontal)

                        Text("This app is based on a comprehensive beginner-friendly Tai Chi plan featuring:")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)

                        VStack(alignment: .leading, spacing: 8) {
                            BulletPoint(text: "3 sessions per week (Mon/Wed/Fri)")
                            BulletPoint(text: "30 minutes per session")
                            BulletPoint(text: "Progressive difficulty over 12 weeks")
                            BulletPoint(text: "Focus on form, breathing, and balance")
                            BulletPoint(text: "Based on Dr. Paul Lam's teachings")
                        }
                        .padding(.horizontal)
                    }

                    Spacer()
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 40)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal)
    }
}

struct BulletPoint: View {
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Text("•")
                .fontWeight(.bold)
            Text(text)
                .font(.subheadline)
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(ProgressTracker())
}
