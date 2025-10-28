//
//  SessionDetailView.swift
//  TaiChiTracker
//
//  Detailed view of a session with exercises
//

import SwiftUI

struct SessionDetailView: View {
    let session: Session
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var progressTracker: ProgressTracker
    @State private var showingActiveSession = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Session header
                    sessionHeader

                    // Session structure
                    sessionStructure

                    // Exercises list
                    exercisesList

                    // Start button
                    startButton
                }
                .padding()
            }
            .navigationTitle(session.type.title)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .background(Color(.systemGroupedBackground))
        }
        .fullScreenCover(isPresented: $showingActiveSession) {
            ActiveSessionView(session: session)
        }
    }

    private var sessionHeader: some View {
        VStack(spacing: 12) {
            Image(systemName: session.type.iconName)
                .font(.system(size: 60))
                .foregroundColor(colorForSession)

            Text(session.type.subtitle)
                .font(.title3)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)

            HStack(spacing: 20) {
                Label("\(session.totalDuration) min", systemImage: "clock")
                Label("\(session.exercises.count) exercises", systemImage: "list.bullet")
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }

    private var sessionStructure: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Session Structure")
                .font(.headline)

            VStack(spacing: 8) {
                StructureRow(
                    icon: "flame.fill",
                    title: "Warm-up",
                    duration: session.warmupDuration,
                    color: .orange
                )

                StructureRow(
                    icon: "figure.tai.chi",
                    title: "Main Practice",
                    duration: session.mainPracticeDuration,
                    color: .blue
                )

                StructureRow(
                    icon: "wind",
                    title: "Cool-down",
                    duration: session.cooldownDuration,
                    color: .cyan
                )
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }

    private var exercisesList: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Exercises")
                .font(.headline)

            ForEach(Array(session.exercises.enumerated()), id: \.element.id) { index, exercise in
                ExerciseRow(exercise: exercise, number: index + 1)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }

    private var startButton: some View {
        Button(action: {
            showingActiveSession = true
        }) {
            HStack {
                Image(systemName: "play.fill")
                Text("Start Session")
                    .fontWeight(.semibold)
            }
            .font(.title3)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(colorForSession)
            .cornerRadius(12)
        }
        .shadow(radius: 4)
    }

    private var colorForSession: Color {
        switch session.type {
        case .sessionA:
            return .blue
        case .sessionB:
            return .green
        case .sessionC:
            return .purple
        }
    }
}

struct StructureRow: View {
    let icon: String
    let title: String
    let duration: Int
    let color: Color

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 30)

            Text(title)
                .font(.subheadline)

            Spacer()

            Text("\(duration) min")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}

struct ExerciseRow: View {
    let exercise: Exercise
    let number: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("\(number)")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(width: 24, height: 24)
                    .background(Color.blue)
                    .cornerRadius(12)

                Image(systemName: exercise.iconName)
                    .foregroundColor(.blue)

                Text(exercise.name)
                    .font(.subheadline)
                    .fontWeight(.medium)

                Spacer()
            }

            VStack(alignment: .leading, spacing: 4) {
                if let reps = exercise.reps {
                    Label("\(exercise.sets) sets × \(reps) reps", systemImage: "repeat")
                        .font(.caption)
                        .foregroundColor(.secondary)
                } else if let duration = exercise.durationMinutes {
                    Label("\(exercise.sets) sets × \(Int(duration)) min", systemImage: "timer")
                        .font(.caption)
                        .foregroundColor(.secondary)
                } else if let duration = exercise.durationSeconds {
                    Label("\(exercise.sets) sets × \(duration)s", systemImage: "timer")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                if exercise.restSeconds > 0 {
                    Label("\(exercise.restSeconds)s rest", systemImage: "pause.circle")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Text(exercise.cue)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .italic()
                    .padding(.top, 2)
            }
            .padding(.leading, 32)
        }
        .padding(.vertical, 8)

        if number < 4 { // Assuming max 4-5 exercises
            Divider()
        }
    }
}

#Preview {
    SessionDetailView(session: SessionManager().sessions[0])
        .environmentObject(ProgressTracker())
}
