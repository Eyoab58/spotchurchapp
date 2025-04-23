//
//  YouTubeService.swift
//  spotchurchapp
//
//  Created by Eyoab Asrat on 4/23/25.
//

import SwiftUI

class YouTubeVideoService: ObservableObject {
    @Published var videos: [YouTubeVideo] = []
    private let apiKey = "AIzaSyCDnTq9gyUczwaldDLdiPSuEHi29KkmytI"
    private let channelId = "UCtBsjKsdqdAFHv_snt-otmA"
    func fetchVideos() {
           guard let url = URL(string:
               "https://www.googleapis.com/youtube/v3/search?part=snippet&channelId=\(channelId)&maxResults=5&order=date&type=video&key=\(apiKey)"
           ) else { return }

           URLSession.shared.dataTask(with: url) { data, response, error in
               guard let data = data else { return }

               do {
                   let decoded = try JSONDecoder().decode(YouTubeResponse.self, from: data)
                   DispatchQueue.main.async {
                       self.videos = decoded.items.map {
                           YouTubeVideo(
                               id: $0.id.videoId,
                               title: $0.snippet.title,
                               thumbnailURL: $0.snippet.thumbnails.high.url
                           )
                       }
                   }
               } catch {
                   print("Error decoding: \(error)")
               }
           }.resume()
       }
   }
// MARK: - Response Models
struct YouTubeResponse: Codable {
    let items: [YouTubeItem]
}

struct YouTubeItem: Codable {
    let id: YouTubeVideoId
    let snippet: YouTubeSnippet
}

struct YouTubeVideoId: Codable {
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


