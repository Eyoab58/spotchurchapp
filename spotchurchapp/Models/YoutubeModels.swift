//
//  YoutubeModels.swift
//  spotchurchapp
//
//  Created by Eyoab Asrat on 5/18/25.
//

import Foundation

struct YouTubeDetailsResponse: Codable {
    let items: [YouTubeDetailsItem]
}

struct YouTubeDetailsItem: Codable {
    let id: String
    let snippet: YouTubeSnippet
    let contentDetails: YouTubeContentDetails
}

struct YouTubeContentDetails: Codable {
    let duration: String
}

struct YouTubeResponse: Codable {
    let items: [YouTubeItem]
}

struct YouTubeItem: Codable {
    let id: YouTubeVideoId
    let snippet: YouTubeSnippet
}

struct YouTubeVideoId: Codable {
    let kind: String
    let videoId: String
}

struct YouTubeSnippet: Codable {
    let title: String
    let thumbnails: YouTubeThumbnails
}

struct YouTubeThumbnails: Codable {
    let high: YouTubeThumbnail
}

struct YouTubeThumbnail: Codable {
    let url: String
}

struct YouTubeVideo: Identifiable {
    let id: String
    let title: String
    let thumbnailURL: String
}
