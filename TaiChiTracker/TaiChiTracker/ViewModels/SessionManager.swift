//
//  SessionManager.swift
//  TaiChiTracker
//
//  Manages sessions and exercise data
//

import Foundation

class SessionManager: ObservableObject {
    @Published var sessions: [Session] = []
    @Published var videoResources: [VideoResource] = []

    init() {
        setupSessions()
        setupVideoResources()
    }

    private func setupSessions() {
        sessions = [
            createSessionA(),
            createSessionB(),
            createSessionC()
        ]
    }

    private func createSessionA() -> Session {
        let exercises = [
            Exercise(
                name: "Feet-timing & Weight Shift Drill",
                description: "Slow step with full weight transfer",
                sets: 3,
                durationMinutes: 2,
                restSeconds: 45,
                cue: "Slow step → transfer weight fully to front foot, feel heel to toe roll",
                iconName: "figure.walk"
            ),
            Exercise(
                name: "Commencing Form (Opening)",
                description: "Opening movement with breathing",
                sets: 3,
                durationMinutes: 1,
                restSeconds: 30,
                cue: "Soft knees, breathe in on rise, out on settle",
                iconName: "arrow.up.circle"
            ),
            Exercise(
                name: "Parting Wild Horse's Mane",
                description: "Alternate right and left sides",
                sets: 3,
                reps: 3,
                restSeconds: 45,
                cue: "Torso rotates with hips, not shoulders; eyes follow hands",
                iconName: "hands.sparkles"
            ),
            Exercise(
                name: "Single Whip Basic Posture",
                description: "Static holds for stability",
                sets: 3,
                durationSeconds: 25,
                restSeconds: 30,
                cue: "Lengthen spine, relax shoulders, keep front knee soft",
                iconName: "figure.stand"
            )
        ]

        return Session(
            type: .sessionA,
            exercises: exercises
        )
    }

    private func createSessionB() -> Session {
        let exercises = [
            Exercise(
                name: "Tai Chi Walking",
                description: "Heel-toe with mindful weight transfer",
                sets: 2,
                durationMinutes: 3,
                restSeconds: 60,
                cue: "Walk slowly, heel-toe, mindful hips",
                iconName: "figure.walk"
            ),
            Exercise(
                name: "Repulse Monkey / Brush Knee",
                description: "Alternate practice in sequence",
                sets: 2,
                durationMinutes: 4,
                restSeconds: 60,
                cue: "Alternate moves smoothly, maintain flow",
                iconName: "figure.tai.chi"
            ),
            Exercise(
                name: "Golden Rooster / Single-leg Balance",
                description: "Balance holds per leg",
                sets: 3,
                durationSeconds: 25,
                restSeconds: 45,
                cue: "Use chair nearby if needed. Progression: +5-10s each week",
                iconName: "figure.stand.line.dotted.figure.stand"
            ),
            Exercise(
                name: "Short Continuous Flow",
                description: "Gentle link of 3-5 moves",
                sets: 1,
                durationMinutes: 4.5,
                restSeconds: 0,
                cue: "Smooth transitions, no stopping, continuous breathing",
                iconName: "figure.flexibility"
            )
        ]

        return Session(
            type: .sessionB,
            exercises: exercises
        )
    }

    private func createSessionC() -> Session {
        let exercises = [
            Exercise(
                name: "8-Form: Block 1 (Forms 1-3)",
                description: "Practice first three forms",
                sets: 2,
                durationMinutes: 3,
                restSeconds: 45,
                cue: "Follow video for guidance, slow and controlled",
                iconName: "1.square"
            ),
            Exercise(
                name: "8-Form: Block 2 (Forms 4-6)",
                description: "Practice forms 4 through 6",
                sets: 2,
                durationMinutes: 3,
                restSeconds: 45,
                cue: "Maintain breathing rhythm, smooth transitions",
                iconName: "2.square"
            ),
            Exercise(
                name: "8-Form: Link 1-6 Continuously",
                description: "Connect all six forms together",
                sets: 1,
                durationMinutes: 4,
                restSeconds: 60,
                cue: "Flow through entire sequence without stopping",
                iconName: "link"
            ),
            Exercise(
                name: "Core Gentle Isometrics",
                description: "Plank variations or standing core bracing",
                sets: 3,
                durationSeconds: 40,
                restSeconds: 45,
                cue: "Choose standing if low-back sensitive",
                iconName: "figure.core.training"
            ),
            Exercise(
                name: "Mobility Finish",
                description: "Ankle and hip openers",
                sets: 1,
                durationMinutes: 2.5,
                restSeconds: 0,
                cue: "Gentle stretches, breathe deeply",
                iconName: "figure.flexibility"
            )
        ]

        return Session(
            type: .sessionC,
            exercises: exercises
        )
    }

    private func setupVideoResources() {
        videoResources = [
            // Foundations
            VideoResource(
                title: "Dr Paul Lam - Tai Chi for Beginners",
                category: .foundations,
                url: "https://youtube.com/watch?v=example1",
                description: "Commencing, Parting Wild Horse's Mane, Brush Knee, Single Whip",
                duration: "20 min"
            ),

            // Warm-up
            VideoResource(
                title: "Dr Paul Lam - 20 Min Warm Up",
                category: .warmup,
                url: "https://youtube.com/watch?v=example2",
                description: "Joint mobility and gentle warm-up routine",
                duration: "20 min"
            ),

            // 8-Form
            VideoResource(
                title: "8 Form Yang Style Tutorial",
                category: .eightForm,
                url: "https://youtube.com/watch?v=example3",
                description: "Compact beginner-friendly form with follow-along",
                duration: "15 min"
            ),

            // 24-Form
            VideoResource(
                title: "24 Form Step-by-Step",
                category: .twentyFourForm,
                url: "https://youtube.com/watch?v=example4",
                description: "Longer form for future progression",
                duration: "35 min"
            )
        ]
    }

    func getSession(for type: SessionType) -> Session? {
        sessions.first { $0.type == type }
    }

    func getVideos(for category: VideoCategory) -> [VideoResource] {
        videoResources.filter { $0.category == category }
    }
}
