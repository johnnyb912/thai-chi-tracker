//
//  ActiveSessionView.swift
//  TaiChiTracker
//
//  Active session view with timer and exercise guidance
//

import SwiftUI
import AVFoundation
import Combine

enum SessionPhase: Equatable {
    case warmup
    case exercise(index: Int, set: Int)
    case rest
    case cooldown
    case completed
}

class SessionTimer: ObservableObject {
    @Published var phase: SessionPhase = .warmup
    @Published var timeRemaining: Int = 0
    @Published var isRunning: Bool = false
    @Published var currentExerciseIndex: Int = 0
    @Published var currentSet: Int = 1

    private var timer: Timer?
    private let session: Session
    private var audioPlayer: AVAudioPlayer?

    init(session: Session) {
        self.session = session
        self.timeRemaining = session.warmupDuration * 60
    }

    func start() {
        isRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.tick()
        }
    }

    func pause() {
        isRunning = false
        timer?.invalidate()
    }

    func resume() {
        isRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.tick()
        }
    }

    func skip() {
        advancePhase()
    }

    private func tick() {
        if timeRemaining > 0 {
            timeRemaining -= 1
        } else {
            advancePhase()
        }
    }

    private func advancePhase() {
        switch phase {
        case .warmup:
            // Move to first exercise
            phase = .exercise(index: 0, set: 1)
            currentExerciseIndex = 0
            currentSet = 1
            setExerciseTime()

        case .exercise(let index, let set):
            let exercise = session.exercises[index]

            if set < exercise.sets {
                // Move to rest period
                phase = .rest
                timeRemaining = exercise.restSeconds
            } else if index < session.exercises.count - 1 {
                // Move to next exercise
                currentExerciseIndex = index + 1
                currentSet = 1
                phase = .exercise(index: index + 1, set: 1)
                setExerciseTime()
            } else {
                // Move to cooldown
                phase = .cooldown
                timeRemaining = session.cooldownDuration * 60
            }

        case .rest:
            // Move to next set of current exercise
            currentSet += 1
            phase = .exercise(index: currentExerciseIndex, set: currentSet)
            setExerciseTime()

        case .cooldown:
            phase = .completed
            timer?.invalidate()

        case .completed:
            timer?.invalidate()
        }

        playSound()
    }

    private func setExerciseTime() {
        let exercise = session.exercises[currentExerciseIndex]
        if let minutes = exercise.durationMinutes {
            timeRemaining = Int(minutes * 60)
        } else if let seconds = exercise.durationSeconds {
            timeRemaining = seconds
        } else {
            timeRemaining = 60 // Default 1 minute if no duration specified
        }
    }

    private func playSound() {
        // Simple beep sound (in production, use actual sound files)
        AudioServicesPlaySystemSound(1103)
    }

    func stop() {
        timer?.invalidate()
        isRunning = false
    }

    deinit {
        timer?.invalidate()
    }
}

struct ActiveSessionView: View {
    let session: Session
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var progressTracker: ProgressTracker
    @StateObject private var sessionTimer: SessionTimer
    @State private var showingCompleteSheet = false
    @State private var sessionRPE: Double = 5
    @State private var sessionNotes: String = ""

    init(session: Session) {
        self.session = session
        _sessionTimer = StateObject(wrappedValue: SessionTimer(session: session))
    }

    var body: some View {
        ZStack {
            // Background color based on phase
            phaseBackgroundColor
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Top bar with close button
                topBar

                Spacer()

                // Main content based on phase
                mainContent

                Spacer()

                // Timer display
                timerDisplay

                Spacer()

                // Control buttons
                controlButtons
            }
            .padding()
        }
        .sheet(isPresented: $showingCompleteSheet) {
            CompleteSessionSheet(
                session: session,
                rpe: $sessionRPE,
                notes: $sessionNotes,
                onComplete: completeSession
            )
        }
        .onAppear {
            sessionTimer.start()
        }
        .onDisappear {
            sessionTimer.stop()
        }
        .onChange(of: sessionTimer.phase) {
            if case .completed = sessionTimer.phase {
                showingCompleteSheet = true
            }
        }
    }

    private var topBar: some View {
        HStack {
            Button(action: {
                sessionTimer.stop()
                dismiss()
            }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.title2)
                    .foregroundColor(.white)
            }

            Spacer()

            Text(phaseTitle)
                .font(.headline)
                .foregroundColor(.white)

            Spacer()

            // Placeholder for symmetry
            Image(systemName: "xmark.circle.fill")
                .font(.title2)
                .opacity(0)
        }
    }

    private var mainContent: some View {
        VStack(spacing: 20) {
            // Phase icon
            Image(systemName: phaseIcon)
                .font(.system(size: 80))
                .foregroundColor(.white)

            // Exercise name or phase description
            Text(phaseDescription)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)

            // Exercise cue
            if case .exercise(let index, _) = sessionTimer.phase {
                Text(session.exercises[index].cue)
                    .font(.body)
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }

            // Set indicator
            if case .exercise(let index, let set) = sessionTimer.phase {
                Text("Set \(set) of \(session.exercises[index].sets)")
                    .font(.headline)
                    .foregroundColor(.white.opacity(0.8))
            }
        }
    }

    private var timerDisplay: some View {
        VStack(spacing: 8) {
            Text(timeString)
                .font(.system(size: 72, weight: .bold, design: .rounded))
                .foregroundColor(.white)

            ProgressView(value: progress)
                .tint(.white)
                .scaleEffect(x: 1, y: 2, anchor: .center)
                .padding(.horizontal, 40)
        }
    }

    private var controlButtons: some View {
        HStack(spacing: 40) {
            // Pause/Resume button
            Button(action: {
                if sessionTimer.isRunning {
                    sessionTimer.pause()
                } else {
                    sessionTimer.resume()
                }
            }) {
                Image(systemName: sessionTimer.isRunning ? "pause.circle.fill" : "play.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.white)
            }

            // Skip button
            Button(action: {
                sessionTimer.skip()
            }) {
                Image(systemName: "forward.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.white.opacity(0.8))
            }
        }
        .padding(.bottom, 40)
    }

    private var phaseBackgroundColor: Color {
        switch sessionTimer.phase {
        case .warmup:
            return Color.orange.opacity(0.9)
        case .exercise:
            return Color.blue.opacity(0.9)
        case .rest:
            return Color.green.opacity(0.9)
        case .cooldown:
            return Color.cyan.opacity(0.9)
        case .completed:
            return Color.purple.opacity(0.9)
        }
    }

    private var phaseTitle: String {
        switch sessionTimer.phase {
        case .warmup:
            return "Warm-up"
        case .exercise:
            return "Exercise"
        case .rest:
            return "Rest"
        case .cooldown:
            return "Cool-down"
        case .completed:
            return "Completed"
        }
    }

    private var phaseIcon: String {
        switch sessionTimer.phase {
        case .warmup:
            return "flame.fill"
        case .exercise:
            return "figure.tai.chi"
        case .rest:
            return "pause.circle.fill"
        case .cooldown:
            return "wind"
        case .completed:
            return "checkmark.circle.fill"
        }
    }

    private var phaseDescription: String {
        switch sessionTimer.phase {
        case .warmup:
            return "Gentle joint rotations\nSlow marching in place"
        case .exercise(let index, _):
            return session.exercises[index].name
        case .rest:
            return "Rest & Breathe"
        case .cooldown:
            return "Standing breathing\nGentle stretches"
        case .completed:
            return "Great Work!"
        }
    }

    private var timeString: String {
        let minutes = sessionTimer.timeRemaining / 60
        let seconds = sessionTimer.timeRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    private var progress: Double {
        // Calculate progress based on phase
        let totalTime: Int
        switch sessionTimer.phase {
        case .warmup:
            totalTime = session.warmupDuration * 60
        case .exercise(let index, _):
            let exercise = session.exercises[index]
            totalTime = Int((exercise.durationMinutes ?? 1) * 60)
        case .rest:
            if case .exercise(let index, _) = sessionTimer.phase {
                totalTime = session.exercises[index].restSeconds
            } else {
                totalTime = 30
            }
        case .cooldown:
            totalTime = session.cooldownDuration * 60
        case .completed:
            return 1.0
        }

        return 1.0 - (Double(sessionTimer.timeRemaining) / Double(totalTime))
    }

    private func completeSession() {
        let completedSession = CompletedSession(
            sessionType: session.type,
            duration: session.totalDuration,
            rpe: Int(sessionRPE),
            notes: sessionNotes.isEmpty ? nil : sessionNotes
        )
        progressTracker.addCompletedSession(completedSession)
        dismiss()
    }
}

struct CompleteSessionSheet: View {
    let session: Session
    @Binding var rpe: Double
    @Binding var notes: String
    let onComplete: () -> Void
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            Form {
                Section {
                    VStack(spacing: 16) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.green)

                        Text("Session Complete!")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    .frame(maxWidth: .infinity)
                    .listRowBackground(Color.clear)
                }

                Section(header: Text("Rate Your Effort (1-10)")) {
                    VStack(spacing: 8) {
                        Slider(value: $rpe, in: 1...10, step: 1)
                        Text("\(Int(rpe)) - \(rpeDescription)")
                            .font(.headline)
                            .foregroundColor(rpeColor)
                    }
                }

                Section(header: Text("Notes (Optional)")) {
                    TextEditor(text: $notes)
                        .frame(height: 100)
                }

                Section {
                    Button(action: {
                        onComplete()
                        dismiss()
                    }) {
                        Text("Save & Complete")
                            .frame(maxWidth: .infinity)
                            .fontWeight(.semibold)
                    }
                }
            }
            .navigationTitle("Complete Session")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var rpeDescription: String {
        switch Int(rpe) {
        case 1...3:
            return "Light"
        case 4...6:
            return "Moderate"
        case 7...8:
            return "Hard"
        case 9...10:
            return "Very Hard"
        default:
            return ""
        }
    }

    private var rpeColor: Color {
        switch Int(rpe) {
        case 1...3:
            return .green
        case 4...6:
            return .yellow
        case 7...8:
            return .orange
        case 9...10:
            return .red
        default:
            return .blue
        }
    }
}

#Preview {
    ActiveSessionView(session: SessionManager().sessions[0])
        .environmentObject(ProgressTracker())
}
