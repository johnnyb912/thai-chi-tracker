//
//  HomeView.swift
//  TaiChiTracker
//
//  Home dashboard with overview and next session
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var progressTracker: ProgressTracker
    @EnvironmentObject var sessionManager: SessionManager
    @State private var showingSessionDetail = false
    @State private var selectedSession: Session?

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header with week
                    weekHeaderCard

                    // Stats overview
                    statsGrid

                    // Next session card
                    nextSessionCard

                    // Quick access to all sessions
                    allSessionsSection
                }
                .padding()
            }
            .navigationTitle("Tai Chi Journey")
            .background(Color(.systemGroupedBackground))
        }
        .sheet(isPresented: $showingSessionDetail) {
            if let session = selectedSession {
                SessionDetailView(session: session)
            }
        }
    }

    private var weekHeaderCard: some View {
        VStack(spacing: 8) {
            Text("Week \(progressTracker.currentWeek) of 12")
                .font(.headline)
                .foregroundColor(.secondary)

            ProgressView(value: Double(progressTracker.currentWeek), total: 12)
                .tint(.blue)

            Text(progressMessage)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }

    private var progressMessage: String {
        switch progressTracker.currentWeek {
        case 1...2:
            return "Focus: Learning basic stance and weight-shift"
        case 3...4:
            return "Focus: Increasing continuous practice time"
        case 5...8:
            return "Focus: Learning the 8-form short set"
        case 9...12:
            return "Focus: Working toward 24-form sections"
        default:
            return "Keep up the practice!"
        }
    }

    private var statsGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
            StatCard(
                title: "Streak",
                value: "\(progressTracker.getStreak())",
                icon: "flame.fill",
                color: .orange
            )

            StatCard(
                title: "Total Sessions",
                value: "\(progressTracker.getTotalSessions())",
                icon: "checkmark.circle.fill",
                color: .green
            )

            StatCard(
                title: "This Week",
                value: "\(progressTracker.getSessionsThisWeek().count)/3",
                icon: "calendar.badge.clock",
                color: .blue
            )

            StatCard(
                title: "Avg RPE",
                value: String(format: "%.1f/10", progressTracker.getAverageRPE()),
                icon: "heart.fill",
                color: .red
            )
        }
    }

    private var nextSessionCard: some View {
        let nextSessionType = progressTracker.getNextScheduledSession()
        let nextSession = sessionManager.getSession(for: nextSessionType)

        return VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                Text("Next Session")
                    .font(.headline)
            }

            if let session = nextSession {
                Button(action: {
                    selectedSession = session
                    showingSessionDetail = true
                }) {
                    SessionCard(session: session, showChevron: true)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }

    private var allSessionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("All Sessions")
                .font(.headline)
                .padding(.horizontal)

            ForEach(sessionManager.sessions) { session in
                Button(action: {
                    selectedSession = session
                    showingSessionDetail = true
                }) {
                    SessionCard(session: session, showChevron: true)
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.horizontal)
            }
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)

            Text(value)
                .font(.title2)
                .fontWeight(.bold)

            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

struct SessionCard: View {
    let session: Session
    var showChevron: Bool = false

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: session.type.iconName)
                .font(.title)
                .foregroundColor(colorForSession(session.type))
                .frame(width: 50, height: 50)
                .background(colorForSession(session.type).opacity(0.2))
                .cornerRadius(10)

            VStack(alignment: .leading, spacing: 4) {
                Text(session.type.title)
                    .font(.headline)
                    .foregroundColor(.primary)

                Text(session.type.subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)

                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .font(.caption)
                    Text("\(session.totalDuration) min")
                        .font(.caption)
                }
                .foregroundColor(.secondary)
            }

            Spacer()

            if showChevron {
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }

    private func colorForSession(_ type: SessionType) -> Color {
        switch type {
        case .sessionA:
            return .blue
        case .sessionB:
            return .green
        case .sessionC:
            return .purple
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(ProgressTracker())
        .environmentObject(SessionManager())
}
