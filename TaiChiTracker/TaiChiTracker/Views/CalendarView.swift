//
//  CalendarView.swift
//  TaiChiTracker
//
//  Calendar view for scheduling and tracking sessions
//

import SwiftUI

struct CalendarView: View {
    @EnvironmentObject var progressTracker: ProgressTracker
    @EnvironmentObject var sessionManager: SessionManager
    @State private var selectedDate = Date()
    @State private var showingSessionPicker = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Week overview
                    weekOverview

                    // Calendar
                    calendarGrid

                    // Schedule for selected date
                    selectedDateSchedule

                    // Recommended schedule
                    recommendedSchedule
                }
                .padding()
            }
            .navigationTitle("Schedule")
            .background(Color(.systemGroupedBackground))
        }
    }

    private var weekOverview: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "calendar.badge.clock")
                    .foregroundColor(.blue)
                Text("This Week")
                    .font(.headline)

                Spacer()

                Text("Week \(progressTracker.currentWeek)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            let sessionsThisWeek = progressTracker.getSessionsThisWeek()
            HStack(spacing: 40) {
                VStack {
                    Text("\(sessionsThisWeek.count)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                    Text("Completed")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                VStack {
                    Text("\(3 - sessionsThisWeek.count)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.orange)
                    Text("Remaining")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                VStack {
                    Text(String(format: "%.0f%%", Double(sessionsThisWeek.count) / 3.0 * 100))
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                    Text("Progress")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }

    private var calendarGrid: some View {
        VStack(spacing: 16) {
            // Month and year
            HStack {
                Button(action: {
                    selectedDate = Calendar.current.date(byAdding: .month, value: -1, to: selectedDate) ?? selectedDate
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.blue)
                }

                Spacer()

                Text(monthYearString)
                    .font(.headline)

                Spacer()

                Button(action: {
                    selectedDate = Calendar.current.date(byAdding: .month, value: 1, to: selectedDate) ?? selectedDate
                }) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.blue)
                }
            }

            // Weekday headers
            HStack(spacing: 0) {
                ForEach(weekdaySymbols, id: \.self) { symbol in
                    Text(symbol)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity)
                }
            }

            // Calendar days
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 12) {
                ForEach(daysInMonth, id: \.self) { date in
                    if let date = date {
                        CalendarDayCell(
                            date: date,
                            isSelected: Calendar.current.isDate(date, inSameDayAs: selectedDate),
                            hasSession: hasSession(on: date),
                            isToday: Calendar.current.isDateInToday(date)
                        )
                        .onTapGesture {
                            selectedDate = date
                        }
                    } else {
                        Color.clear
                            .frame(height: 50)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }

    private var selectedDateSchedule: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(selectedDateString)
                .font(.headline)

            if hasSession(on: selectedDate) {
                let sessions = getSessionsForDate(selectedDate)
                ForEach(sessions) { session in
                    CompletedSessionRow(session: session)
                }
            } else {
                Text("No sessions recorded")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }

    private var recommendedSchedule: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(.yellow)
                Text("Recommended Schedule")
                    .font(.headline)
            }

            VStack(alignment: .leading, spacing: 8) {
                ScheduleRow(day: "Monday", sessionType: .sessionA)
                ScheduleRow(day: "Wednesday", sessionType: .sessionB)
                ScheduleRow(day: "Friday", sessionType: .sessionC)
            }

            Text("Rest days between sessions for recovery")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.top, 4)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }

    // Helper properties and methods

    private var weekdaySymbols: [String] {
        let formatter = DateFormatter()
        return formatter.veryShortWeekdaySymbols
    }

    private var monthYearString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: selectedDate)
    }

    private var selectedDateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: selectedDate)
    }

    private var daysInMonth: [Date?] {
        let calendar = Calendar.current
        let interval = calendar.dateInterval(of: .month, for: selectedDate)!
        let firstWeekday = calendar.component(.weekday, from: interval.start)
        let daysInMonth = calendar.range(of: .day, in: .month, for: selectedDate)!.count

        var days: [Date?] = []

        // Add empty cells for days before the start of the month
        for _ in 1..<firstWeekday {
            days.append(nil)
        }

        // Add actual days
        for day in 1...daysInMonth {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: interval.start) {
                days.append(date)
            }
        }

        return days
    }

    private func hasSession(on date: Date) -> Bool {
        let calendar = Calendar.current
        return progressTracker.completedSessions.contains { session in
            calendar.isDate(session.date, inSameDayAs: date)
        }
    }

    private func getSessionsForDate(_ date: Date) -> [CompletedSession] {
        let calendar = Calendar.current
        return progressTracker.completedSessions.filter { session in
            calendar.isDate(session.date, inSameDayAs: date)
        }
    }
}

struct CalendarDayCell: View {
    let date: Date
    let isSelected: Bool
    let hasSession: Bool
    let isToday: Bool

    var body: some View {
        VStack(spacing: 4) {
            Text("\(Calendar.current.component(.day, from: date))")
                .font(.subheadline)
                .fontWeight(isToday ? .bold : .regular)
                .foregroundColor(isSelected ? .white : (isToday ? .blue : .primary))

            if hasSession {
                Circle()
                    .fill(isSelected ? Color.white : Color.green)
                    .frame(width: 6, height: 6)
            }
        }
        .frame(height: 50)
        .frame(maxWidth: .infinity)
        .background(isSelected ? Color.blue : (isToday ? Color.blue.opacity(0.1) : Color.clear))
        .cornerRadius(8)
    }
}

struct CompletedSessionRow: View {
    let session: CompletedSession

    var body: some View {
        HStack {
            Image(systemName: session.sessionType.iconName)
                .foregroundColor(colorForSession)
                .frame(width: 30)

            VStack(alignment: .leading, spacing: 4) {
                Text(session.sessionType.title)
                    .font(.subheadline)
                    .fontWeight(.medium)

                HStack(spacing: 12) {
                    Label("\(session.duration) min", systemImage: "clock")
                    Label("RPE \(session.rpe)", systemImage: "heart.fill")
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }

            Spacer()

            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(8)
    }

    private var colorForSession: Color {
        switch session.sessionType {
        case .sessionA:
            return .blue
        case .sessionB:
            return .green
        case .sessionC:
            return .purple
        }
    }
}

struct ScheduleRow: View {
    let day: String
    let sessionType: SessionType

    var body: some View {
        HStack {
            Text(day)
                .font(.subheadline)
                .fontWeight(.medium)
                .frame(width: 100, alignment: .leading)

            Image(systemName: sessionType.iconName)
                .foregroundColor(colorForSession)
                .frame(width: 24)

            Text(sessionType.title)
                .font(.subheadline)
                .foregroundColor(.secondary)

            Spacer()
        }
        .padding(.vertical, 4)
    }

    private var colorForSession: Color {
        switch sessionType {
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
    CalendarView()
        .environmentObject(ProgressTracker())
        .environmentObject(SessionManager())
}
