//
//  Exercise.swift
//  TaiChiTracker
//
//  Model for individual exercises
//

import Foundation

struct Exercise: Identifiable, Codable {
    let id: UUID
    let name: String
    let description: String
    let sets: Int
    let reps: Int?
    let durationMinutes: Double?
    let durationSeconds: Int?
    let restSeconds: Int
    let cue: String
    let iconName: String

    init(
        id: UUID = UUID(),
        name: String,
        description: String,
        sets: Int,
        reps: Int? = nil,
        durationMinutes: Double? = nil,
        durationSeconds: Int? = nil,
        restSeconds: Int = 30,
        cue: String,
        iconName: String = "figure.tai.chi"
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.sets = sets
        self.reps = reps
        self.durationMinutes = durationMinutes
        self.durationSeconds = durationSeconds
        self.restSeconds = restSeconds
        self.cue = cue
        self.iconName = iconName
    }
}
