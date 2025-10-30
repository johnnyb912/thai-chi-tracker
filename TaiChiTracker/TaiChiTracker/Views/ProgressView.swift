//
//  ProgressView.swift
//  TaiChiTracker
//
//  Progress tracking view with charts and metrics
//

import SwiftUI
import Charts

struct ProgressTrackingView: View {
    @EnvironmentObject var progressTracker: ProgressTracker
    @State private var showingAddMetric = false
    @State private var selectedMetricType: MetricType = .balance

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Overall progress card
                    overallProgressCard

                    // Session history chart
                    sessionHistoryChart

                    // Metrics tracking
                    metricsSection

                    // Add metric button
                    addMetricButton
                }
                .padding()
            }
            .navigationTitle("Progress")
            .background(Color(.systemGroupedBackground))
        }
        .sheet(isPresented: $showingAddMetric) {
            AddMetricView()
        }
    }

    private var overallProgressCard: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .foregroundColor(.blue)
                Text("Overall Progress")
                    .font(.headline)

                Spacer()
            }

            // Progress stats
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                ProgressStatBox(
                    title: "Week",
                    value: "\(progressTracker.currentWeek)/12",
                    icon: "calendar",
                    color: .blue
                )

                ProgressStatBox(
                    title: "Total Sessions",
                    value: "\(progressTracker.getTotalSessions())",
                    icon: "checkmark.circle",
                    color: .green
                )

                ProgressStatBox(
                    title: "Streak",
                    value: "\(progressTracker.getStreak())",
                    icon: "flame",
                    color: .orange
                )

                ProgressStatBox(
                    title: "Avg RPE",
                    value: String(format: "%.1f", progressTracker.getAverageRPE()),
                    icon: "heart",
                    color: .red
                )
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }

    private var sessionHistoryChart: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Session History")
                .font(.headline)

            if !progressTracker.completedSessions.isEmpty {
                let last30Days = getLast30DaysSessions()

                Chart(last30Days) { session in
                    BarMark(
                        x: .value("Date", session.date, unit: .day),
                        y: .value("Duration", session.duration)
                    )
                    .foregroundStyle(colorForSessionType(session.sessionType))
                }
                .frame(height: 200)
                .chartXAxis {
                    AxisMarks(values: .stride(by: .day, count: 7)) { _ in
                        AxisGridLine()
                        AxisValueLabel(format: .dateTime.month().day(), centered: true)
                    }
                }
                .chartYAxis {
                    AxisMarks { _ in
                        AxisGridLine()
                        AxisValueLabel()
                    }
                }

                // Legend
                HStack(spacing: 20) {
                    LegendItem(color: .blue, label: "Session A")
                    LegendItem(color: .green, label: "Session B")
                    LegendItem(color: .purple, label: "Session C")
                }
                .font(.caption)
            } else {
                Text("No sessions recorded yet")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }

    private var metricsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Tracked Metrics")
                .font(.headline)

            if let latestMetric = progressTracker.getLatestMetric() {
                VStack(spacing: 12) {
                    if let balance = latestMetric.singleLegHoldTime {
                        MetricCard(
                            title: "Balance Hold",
                            value: "\(balance)s",
                            icon: "figure.stand.line.dotted.figure.stand",
                            trend: getTrend(for: .balance),
                            color: .blue
                        )
                    }

                    if let continuous = latestMetric.continuousPracticeTime {
                        MetricCard(
                            title: "Continuous Practice",
                            value: "\(continuous) min",
                            icon: "timer",
                            trend: getTrend(for: .continuous),
                            color: .green
                        )
                    }

                    if let moves = latestMetric.movesLearned {
                        MetricCard(
                            title: "Moves Learned",
                            value: "\(moves)",
                            icon: "star.fill",
                            trend: getTrend(for: .moves),
                            color: .yellow
                        )
                    }

                    if let heartRate = latestMetric.restingHeartRate {
                        MetricCard(
                            title: "Resting HR",
                            value: "\(heartRate) bpm",
                            icon: "heart.fill",
                            trend: getTrend(for: .heartRate),
                            color: .red
                        )
                    }

                    if let weight = latestMetric.bodyWeight {
                        MetricCard(
                            title: "Body Weight",
                            value: String(format: "%.1f lbs", weight),
                            icon: "figure",
                            trend: nil,
                            color: .purple
                        )
                    }
                }
            } else {
                Text("No metrics recorded yet")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }

    private var addMetricButton: some View {
        Button(action: {
            showingAddMetric = true
        }) {
            HStack {
                Image(systemName: "plus.circle.fill")
                Text("Add Metric")
                    .fontWeight(.semibold)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .cornerRadius(12)
        }
        .shadow(radius: 4)
    }

    // Helper methods

    private func getLast30DaysSessions() -> [CompletedSession] {
        let calendar = Calendar.current
        let thirtyDaysAgo = calendar.date(byAdding: .day, value: -30, to: Date()) ?? Date()
        return progressTracker.completedSessions.filter { $0.date >= thirtyDaysAgo }
    }

    private func colorForSessionType(_ type: SessionType) -> Color {
        switch type {
        case .sessionA:
            return .blue
        case .sessionB:
            return .green
        case .sessionC:
            return .purple
        }
    }

    private func getTrend(for type: MetricType) -> TrendDirection? {
        let metrics = progressTracker.progressMetrics.sorted { $0.date < $1.date }
        guard metrics.count >= 2 else { return nil }

        let latest = metrics.last!
        let previous = metrics[metrics.count - 2]

        switch type {
        case .balance:
            if let latestValue = latest.singleLegHoldTime,
               let previousValue = previous.singleLegHoldTime {
                return latestValue > previousValue ? .up : (latestValue < previousValue ? .down : .flat)
            }
        case .continuous:
            if let latestValue = latest.continuousPracticeTime,
               let previousValue = previous.continuousPracticeTime {
                return latestValue > previousValue ? .up : (latestValue < previousValue ? .down : .flat)
            }
        case .moves:
            if let latestValue = latest.movesLearned,
               let previousValue = previous.movesLearned {
                return latestValue > previousValue ? .up : (latestValue < previousValue ? .down : .flat)
            }
        case .heartRate:
            if let latestValue = latest.restingHeartRate,
               let previousValue = previous.restingHeartRate {
                return latestValue < previousValue ? .up : (latestValue > previousValue ? .down : .flat)
            }
        }

        return nil
    }
}

enum MetricType {
    case balance, continuous, moves, heartRate
}

enum TrendDirection {
    case up, down, flat
}

struct ProgressStatBox: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
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
        .background(color.opacity(0.1))
        .cornerRadius(10)
    }
}

struct MetricCard: View {
    let title: String
    let value: String
    let icon: String
    let trend: TrendDirection?
    let color: Color

    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 40)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Text(value)
                    .font(.title3)
                    .fontWeight(.bold)
            }

            Spacer()

            if let trend = trend {
                Image(systemName: trendIcon(for: trend))
                    .foregroundColor(trendColor(for: trend))
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(color.opacity(0.3), lineWidth: 1)
        )
    }

    private func trendIcon(for trend: TrendDirection) -> String {
        switch trend {
        case .up:
            return "arrow.up.circle.fill"
        case .down:
            return "arrow.down.circle.fill"
        case .flat:
            return "minus.circle.fill"
        }
    }

    private func trendColor(for trend: TrendDirection) -> Color {
        switch trend {
        case .up:
            return .green
        case .down:
            return .red
        case .flat:
            return .gray
        }
    }
}

struct LegendItem: View {
    let color: Color
    let label: String

    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
            Text(label)
        }
    }
}

struct AddMetricView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var progressTracker: ProgressTracker

    @State private var balanceHold: String = ""
    @State private var continuousPractice: String = ""
    @State private var movesLearned: String = ""
    @State private var restingHR: String = ""
    @State private var bodyWeight: String = ""
    @State private var sleepQuality: Double = 3

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Performance Metrics")) {
                    HStack {
                        Text("Balance Hold (seconds)")
                        Spacer()
                        TextField("0", text: $balanceHold)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 80)
                    }

                    HStack {
                        Text("Continuous Practice (min)")
                        Spacer()
                        TextField("0", text: $continuousPractice)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 80)
                    }

                    HStack {
                        Text("Moves Learned")
                        Spacer()
                        TextField("0", text: $movesLearned)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 80)
                    }
                }

                Section(header: Text("Health Metrics")) {
                    HStack {
                        Text("Resting Heart Rate (bpm)")
                        Spacer()
                        TextField("0", text: $restingHR)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 80)
                    }

                    HStack {
                        Text("Body Weight (lbs)")
                        Spacer()
                        TextField("0", text: $bodyWeight)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 80)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Sleep Quality")
                        HStack {
                            Text("Poor")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Slider(value: $sleepQuality, in: 1...5, step: 1)
                            Text("Great")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Text("\(Int(sleepQuality))/5")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }

                Section {
                    Button(action: saveMetric) {
                        Text("Save Metric")
                            .frame(maxWidth: .infinity)
                            .fontWeight(.semibold)
                    }
                }
            }
            .navigationTitle("Add Metric")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }

    private func saveMetric() {
        let metric = ProgressMetric(
            singleLegHoldTime: Int(balanceHold),
            continuousPracticeTime: Int(continuousPractice),
            movesLearned: Int(movesLearned),
            restingHeartRate: Int(restingHR),
            bodyWeight: Double(bodyWeight),
            sleepQuality: Int(sleepQuality)
        )

        progressTracker.addProgressMetric(metric)
        dismiss()
    }
}

#Preview {
    ProgressTrackingView()
        .environmentObject(ProgressTracker())
}
