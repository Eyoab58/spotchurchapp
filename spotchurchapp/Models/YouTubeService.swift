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
        guard let searchURL = URL(string:
            "https://www.googleapis.com/youtube/v3/search?part=snippet&channelId=\(channelId)&maxResults=10&order=date&type=video&key=\(apiKey)"
        ) else { return }

        URLSession.shared.dataTask(with: searchURL) { data, response, error in
            guard let data = data else { return }

            do {
                let decoded = try JSONDecoder().decode(YouTubeResponse.self, from: data)
                let videoIDs = decoded.items.map { $0.id.videoId }.joined(separator: ",")

                // Now fetch video durations
                self.fetchVideoDetails(videoIDs: videoIDs, snippets: decoded.items)

            } catch {
                print("Error decoding search: \(error)")
            }
        }.resume()
    }

    func fetchVideoDetails(videoIDs: String, snippets: [YouTubeItem]) {
        guard let detailsURL = URL(string:
            "https://www.googleapis.com/youtube/v3/videos?part=contentDetails,snippet&id=\(videoIDs)&key=\(apiKey)"
        ) else { return }

        URLSession.shared.dataTask(with: detailsURL) { data, response, error in
            guard let data = data else { return }

            do {
                let decoded = try JSONDecoder().decode(YouTubeDetailsResponse.self, from: data)

                DispatchQueue.main.async {
                    let filteredVideos = decoded.items.compactMap { item -> YouTubeVideo? in
                        let durationSeconds = self.parseISO8601Duration(item.contentDetails.duration)
                        if durationSeconds >= 60 {
                            return YouTubeVideo(
                                id: item.id,
                                title: item.snippet.title,
                                thumbnailURL: item.snippet.thumbnails.high.url
                            )
                        } else {
                            return nil
                        }
                    }

                    self.videos = filteredVideos
                }
            } catch {
                print("Error decoding details: \(error)")
            }
        }.resume()
    }
    
    func parseISO8601Duration(_ duration: String) -> Int {
        var seconds = 0
        var duration = duration

        guard duration.hasPrefix("PT") else { return 0 }
        duration.removeFirst(2)
        let timeUnits: [(String, Int)] = [("H", 3600), ("M", 60), ("S", 1)]
        for (unit, multiplier) in timeUnits {
            if let range = duration.range(of: "[0-9]+\(unit)", options: .regularExpression) {
                let valueString = String(duration[range]).replacingOccurrences(of: unit, with: "")
                if let value = Int(valueString) {
                    seconds += value * multiplier
                }
                duration.removeSubrange(range)
            }
        }
        return seconds
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


