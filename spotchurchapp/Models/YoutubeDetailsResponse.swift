//
//  YoutubeDetailsResponse.swift
//  spotchurchapp
//
//  Created by Eyoab Asrat on 5/9/25.
//

import SwiftUI

struct YouTubeDetailsResponse: Codable {
    let items: [VideoDetailItem]
}

struct VideoDetailItem: Codable {
    let id: String
    let snippet: YouTubeSnippet
    let contentDetails: VideoContentDetails
}

struct VideoContentDetails: Codable {
    let duration: String
}
