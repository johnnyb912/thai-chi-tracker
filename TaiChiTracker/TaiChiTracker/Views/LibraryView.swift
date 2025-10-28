//
//  LibraryView.swift
//  TaiChiTracker
//
//  Video library for technique resources
//

import SwiftUI
import AVKit

struct LibraryView: View {
    @EnvironmentObject var sessionManager: SessionManager
    @State private var selectedCategory: VideoCategory = .foundations
    @State private var selectedVideo: VideoResource?
    @State private var showingVideoPlayer = false

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Category picker
                categoryPicker

                // Video list
                ScrollView {
                    VStack(spacing: 16) {
                        // Header
                        categoryHeader

                        // Videos
                        ForEach(filteredVideos) { video in
                            VideoCard(video: video)
                                .onTapGesture {
                                    selectedVideo = video
                                    showingVideoPlayer = true
                                }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Video Library")
            .background(Color(.systemGroupedBackground))
        }
        .sheet(isPresented: $showingVideoPlayer) {
            if let video = selectedVideo {
                VideoPlayerView(video: video)
            }
        }
    }

    private var categoryPicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(VideoCategory.allCases, id: \.self) { category in
                    CategoryButton(
                        category: category,
                        isSelected: selectedCategory == category
                    ) {
                        selectedCategory = category
                    }
                }
            }
            .padding()
        }
        .background(Color(.systemBackground))
    }

    private var categoryHeader: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: selectedCategory.iconName)
                    .font(.title2)
                    .foregroundColor(.blue)

                Text(selectedCategory.rawValue)
                    .font(.title2)
                    .fontWeight(.bold)

                Spacer()
            }

            Text(categoryDescription)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }

    private var filteredVideos: [VideoResource] {
        sessionManager.getVideos(for: selectedCategory)
    }

    private var categoryDescription: String {
        switch selectedCategory {
        case .foundations:
            return "Learn the basic movements and postures"
        case .warmup:
            return "Gentle preparation exercises before practice"
        case .eightForm:
            return "Compact beginner-friendly short form"
        case .twentyFourForm:
            return "Extended form for advanced practice"
        }
    }
}

struct CategoryButton: View {
    let category: VideoCategory
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: category.iconName)
                Text(category.rawValue)
            }
            .font(.subheadline)
            .fontWeight(isSelected ? .semibold : .regular)
            .foregroundColor(isSelected ? .white : .primary)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(isSelected ? Color.blue : Color(.systemGray5))
            .cornerRadius(20)
        }
    }
}

struct VideoCard: View {
    let video: VideoResource

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Thumbnail
            ZStack {
                Rectangle()
                    .fill(Color.blue.opacity(0.2))
                    .frame(height: 200)

                VStack(spacing: 8) {
                    Image(systemName: "play.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.blue)

                    Text(video.duration)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.black.opacity(0.7))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }

            // Video info
            VStack(alignment: .leading, spacing: 8) {
                Text(video.title)
                    .font(.headline)
                    .lineLimit(2)

                Text(video.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(3)

                HStack {
                    Image(systemName: video.category.iconName)
                        .font(.caption)
                    Text(video.category.rawValue)
                        .font(.caption)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .foregroundColor(.secondary)
            }
            .padding()
        }
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

struct VideoPlayerView: View {
    let video: VideoResource
    @Environment(\.dismiss) var dismiss
    @State private var showingInfo = false

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Video player placeholder
                ZStack {
                    Color.black

                    VStack(spacing: 16) {
                        Image(systemName: "play.rectangle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.white)

                        Text("Video Player")
                            .font(.title2)
                            .foregroundColor(.white)

                        Text("In a production app, this would use AVPlayer to play the video")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                            .multilineTextAlignment(.center)
                            .padding()

                        Button(action: {
                            // In production: open URL in external player or use AVPlayer
                            if let url = URL(string: video.url) {
                                // UIApplication.shared.open(url)
                            }
                        }) {
                            Text("Open Video Link")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                    }
                }
                .frame(height: 250)

                // Video details
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(video.title)
                                .font(.title2)
                                .fontWeight(.bold)

                            HStack {
                                Label(video.duration, systemImage: "clock")
                                Spacer()
                                Label(video.category.rawValue, systemImage: video.category.iconName)
                            }
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        }

                        Divider()

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(.headline)

                            Text(video.description)
                                .font(.body)
                                .foregroundColor(.secondary)
                        }

                        Divider()

                        // Tips section
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: "lightbulb.fill")
                                    .foregroundColor(.yellow)
                                Text("Practice Tips")
                                    .font(.headline)
                            }

                            VStack(alignment: .leading, spacing: 4) {
                                TipRow(tip: "Watch the video completely before practicing")
                                TipRow(tip: "Practice in a clear, open space")
                                TipRow(tip: "Focus on breathing and form, not speed")
                                TipRow(tip: "Use a chair for balance if needed")
                            }
                        }
                    }
                    .padding()
                }
                .background(Color(.systemGroupedBackground))
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct TipRow: View {
    let tip: String

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
                .font(.caption)

            Text(tip)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    LibraryView()
        .environmentObject(SessionManager())
}
