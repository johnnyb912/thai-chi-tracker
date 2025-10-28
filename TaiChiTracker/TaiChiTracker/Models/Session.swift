//
//  Session.swift
//  TaiChiTracker
//
//  Model for training sessions
//

import Foundation

enum SessionType: String, Codable, CaseIterable {
    case sessionA = "Session A"
    case sessionB = "Session B"
    case sessionC = "Session C"

    var title: String {
        rawValue
    }

    var subtitle: String {
        switch self {
        case .sessionA:
            return "Foundations, Balance & Footwork"
        case .sessionB:
            return "Flow & Walking, Balance Holds"
        case .sessionC:
            return "Short Form Integration + Mobility/Core"
        }
    }

    var iconName: String {
        switch self {
        case .sessionA:
            return "figure.stand"
        case .sessionB:
            return "figure.walk"
        case .sessionC:
            return "figure.mind.and.body"
        }
    }

    var colorName: String {
        switch self {
        case .sessionA:
            return "blue"
        case .sessionB:
            return "green"
        case .sessionC:
            return "purple"
        }
    }
}

struct Session: Identifiable, Codable {
    let id: UUID
    let type: SessionType
    let totalDuration: Int // in minutes
    let warmupDuration: Int
    let mainPracticeDuration: Int
    let cooldownDuration: Int
    let exercises: [Exercise]

    init(
        id: UUID = UUID(),
        type: SessionType,
        totalDuration: Int = 30,
        warmupDuration: Int = 5,
        mainPracticeDuration: Int = 20,
        cooldownDuration: Int = 5,
        exercises: [Exercise]
    ) {
        self.id = id
        self.type = type
        self.totalDuration = totalDuration
        self.warmupDuration = warmupDuration
        self.mainPracticeDuration = mainPracticeDuration
        self.cooldownDuration = cooldownDuration
        self.exercises = exercises
    }
}
