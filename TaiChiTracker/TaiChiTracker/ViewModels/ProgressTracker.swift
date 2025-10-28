//
//  ProgressTracker.swift
//  TaiChiTracker
//
//  Manages user progress and completed sessions
//

import Foundation
import Combine

class ProgressTracker: ObservableObject {
    @Published var completedSessions: [CompletedSession] = []
    @Published var progressMetrics: [ProgressMetric] = []
    @Published var currentWeek: Int = 1
    @Published var startDate: Date

    private let completedSessionsKey = "completedSessions"
    private let progressMetricsKey = "progressMetrics"
    private let currentWeekKey = "currentWeek"
    private let startDateKey = "startDate"

    init() {
        self.startDate = Date()
        loadData()
    }

    func addCompletedSession(_ session: CompletedSession) {
        completedSessions.append(session)
        saveData()
    }

    func addProgressMetric(_ metric: ProgressMetric) {
        progressMetrics.append(metric)
        saveData()
    }

    func getSessionsForWeek(_ weekNumber: Int) -> [CompletedSession] {
        let calendar = Calendar.current
        let weekStart = calendar.date(byAdding: .weekOfYear, value: weekNumber - 1, to: startDate) ?? startDate
        let weekEnd = calendar.date(byAdding: .day, value: 7, to: weekStart) ?? Date()

        return completedSessions.filter { session in
            session.date >= weekStart && session.date < weekEnd
        }
    }

    func getSessionsThisWeek() -> [CompletedSession] {
        getSessionsForWeek(currentWeek)
    }

    func getTotalSessions() -> Int {
        completedSessions.count
    }

    func getAverageRPE() -> Double {
        guard !completedSessions.isEmpty else { return 0 }
        let sum = completedSessions.reduce(0) { $0 + $1.rpe }
        return Double(sum) / Double(completedSessions.count)
    }

    func getNextScheduledSession() -> SessionType {
        let calendar = Calendar.current
        let today = calendar.component(.weekday, from: Date())

        // Monday (2), Wednesday (4), Friday (6)
        switch today {
        case 1, 7: // Sunday or Saturday
            return .sessionA
        case 2: // Monday
            return .sessionA
        case 3: // Tuesday
            return .sessionB
        case 4: // Wednesday
            return .sessionB
        case 5: // Thursday
            return .sessionC
        case 6: // Friday
            return .sessionC
        default:
            return .sessionA
        }
    }

    func getStreak() -> Int {
        guard !completedSessions.isEmpty else { return 0 }

        let sortedSessions = completedSessions.sorted { $0.date > $1.date }
        let calendar = Calendar.current
        var streak = 0
        var lastDate: Date?

        for session in sortedSessions {
            if let last = lastDate {
                let daysDifference = calendar.dateComponents([.day], from: session.date, to: last).day ?? 0
                if daysDifference <= 3 { // Allow 2 rest days between sessions
                    streak += 1
                } else {
                    break
                }
            } else {
                streak = 1
            }
            lastDate = session.date
        }

        return streak
    }

    func getLatestMetric() -> ProgressMetric? {
        progressMetrics.sorted { $0.date > $1.date }.first
    }

    func updateCurrentWeek() {
        let calendar = Calendar.current
        let weeksPassed = calendar.dateComponents([.weekOfYear], from: startDate, to: Date()).weekOfYear ?? 0
        currentWeek = min(weeksPassed + 1, 12) // Cap at 12 weeks
        saveData()
    }

    // MARK: - Persistence

    private func saveData() {
        if let encoded = try? JSONEncoder().encode(completedSessions) {
            UserDefaults.standard.set(encoded, forKey: completedSessionsKey)
        }

        if let encoded = try? JSONEncoder().encode(progressMetrics) {
            UserDefaults.standard.set(encoded, forKey: progressMetricsKey)
        }

        UserDefaults.standard.set(currentWeek, forKey: currentWeekKey)
        UserDefaults.standard.set(startDate, forKey: startDateKey)
    }

    private func loadData() {
        if let data = UserDefaults.standard.data(forKey: completedSessionsKey),
           let decoded = try? JSONDecoder().decode([CompletedSession].self, from: data) {
            completedSessions = decoded
        }

        if let data = UserDefaults.standard.data(forKey: progressMetricsKey),
           let decoded = try? JSONDecoder().decode([ProgressMetric].self, from: data) {
            progressMetrics = decoded
        }

        currentWeek = UserDefaults.standard.integer(forKey: currentWeekKey)
        if currentWeek == 0 {
            currentWeek = 1
        }

        if let savedStartDate = UserDefaults.standard.object(forKey: startDateKey) as? Date {
            startDate = savedStartDate
        } else {
            startDate = Date()
        }

        updateCurrentWeek()
    }
}
