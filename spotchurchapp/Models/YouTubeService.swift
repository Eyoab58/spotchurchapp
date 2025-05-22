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
    
    func fetchVideos() async {
        let urlString = "https://www.googleapis.com/youtube/v3/search?part=snippet&channelId=\(channelId)&maxResults=10&order=date&type=video&key=\(apiKey)"

        guard let url = URL(string: urlString) else {
            print("❌ Invalid URL")
            return
        }

        let config = URLSessionConfiguration.default
        #if targetEnvironment(simulator)
        config.tlsMinimumSupportedProtocolVersion = .TLSv12
        config.tlsMaximumSupportedProtocolVersion = .TLSv12
        #endif
        let session = URLSession(configuration: config)

        do {
            let (data, response) = try await session.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                return
            }

            print("Status Code: \(httpResponse.statusCode)")

            if httpResponse.statusCode != 200 {
                if let raw = String(data: data, encoding: .utf8) {
                    print("Error Response: \(raw)")
                }
                return
            }

            if let raw = String(data: data, encoding: .utf8) {
                print("Raw Response: \(raw)")
            }

            let decoded = try JSONDecoder().decode(YouTubeResponse.self, from: data)

            DispatchQueue.main.async {
                self.videos = decoded.items
                    .filter { !$0.snippet.title.contains("#") } // exclude hashtag titles
                    .map {
                        YouTubeVideo(
                            id: $0.id.videoId,
                            title: $0.snippet.title,
                            thumbnailURL: $0.snippet.thumbnails.high.url
                        )
                    }
            }
        } catch {
            print("Error fetching videos: \(error.localizedDescription)")
            print("📛 Full Error: \(error)")
        }
    }



    func fetchVideoDetails(videoIDs: String) async {
            let urlString =
            "https://www.googleapis.com/youtube/v3/videos?part=contentDetails,snippet&id=\(videoIDs)&key=\(apiKey)"

            guard let url = URL(string: urlString) else {
                print("Invalid details URL")
                return
            }

            do {
                let (data, response) = try await URLSession.shared.data(from: url)

                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    print("Bad detail response")
                    return
                }

                let decoded = try JSONDecoder().decode(YouTubeDetailsResponse.self, from: data)

                self.videos = decoded.items.map { item in
                    YouTubeVideo(
                        id: item.id,
                        title: item.snippet.title,
                        thumbnailURL: item.snippet.thumbnails.high.url
                    )
                }
            } catch {
                print("Error decoding details: \(error)")
            }
    }
}

