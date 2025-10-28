//
//  VideoResource.swift
//  TaiChiTracker
//
//  Model for technique video resources
//

import Foundation

enum VideoCategory: String, Codable, CaseIterable {
    case foundations = "Foundations"
    case warmup = "Warm-up"
    case eightForm = "8-Form"
    case twentyFourForm = "24-Form"

    var iconName: String {
        switch self {
        case .foundations:
            return "book.fill"
        case .warmup:
            return "flame.fill"
        case .eightForm:
            return "8.square.fill"
        case .twentyFourForm:
            return "24.square.fill"
        }
    }
}

struct VideoResource: Identifiable, Codable {
    let id: UUID
    let title: String
    let category: VideoCategory
    let url: String
    let description: String
    let thumbnailName: String?
    let duration: String

    init(
        id: UUID = UUID(),
        title: String,
        category: VideoCategory,
        url: String,
        description: String,
        thumbnailName: String? = nil,
        duration: String
    ) {
        self.id = id
        self.title = title
        self.category = category
        self.url = url
        self.description = description
        self.thumbnailName = thumbnailName
        self.duration = duration
    }
}
