//
//  CompletedSession.swift
//  TaiChiTracker
//
//  Model for tracking completed sessions
//

import Foundation

struct CompletedSession: Identifiable, Codable {
    let id: UUID
    let sessionType: SessionType
    let date: Date
    let duration: Int // actual duration in minutes
    let rpe: Int // Rate of Perceived Exertion (1-10)
    let notes: String?

    init(
        id: UUID = UUID(),
        sessionType: SessionType,
        date: Date = Date(),
        duration: Int,
        rpe: Int,
        notes: String? = nil
    ) {
        self.id = id
        self.sessionType = sessionType
        self.date = date
        self.duration = duration
        self.rpe = rpe
        self.notes = notes
    }
}

struct ProgressMetric: Identifiable, Codable {
    let id: UUID
    let date: Date
    let singleLegHoldTime: Int? // in seconds
    let continuousPracticeTime: Int? // in minutes
    let fingertipToFloorDistance: Double? // in cm
    let restingHeartRate: Int?
    let bodyWeight: Double? // in lbs
    let sleepQuality: Int? // 1-5 scale
    let movesLearned: Int?

    init(
        id: UUID = UUID(),
        date: Date = Date(),
        singleLegHoldTime: Int? = nil,
        continuousPracticeTime: Int? = nil,
        fingertipToFloorDistance: Double? = nil,
        restingHeartRate: Int? = nil,
        bodyWeight: Double? = nil,
        sleepQuality: Int? = nil,
        movesLearned: Int? = nil
    ) {
        self.id = id
        self.date = date
        self.singleLegHoldTime = singleLegHoldTime
        self.continuousPracticeTime = continuousPracticeTime
        self.fingertipToFloorDistance = fingertipToFloorDistance
        self.restingHeartRate = restingHeartRate
        self.bodyWeight = bodyWeight
        self.sleepQuality = sleepQuality
        self.movesLearned = movesLearned
    }
}
