//
//  HomeView.swift
//  spotchurchapp
//
//  Created by Eyoab Asrat on 3/17/25.
//

import SwiftUI
import WebKit
import FirebaseAuth

import SwiftUI
import WebKit
import FirebaseAuth

struct YoutubePlayerView: UIViewRepresentable {
    let videoId: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.configuration.allowsInlineMediaPlayback = true
        webView.configuration.mediaTypesRequiringUserActionForPlayback = []
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let embedURLString = "https://www.youtube.com/embed/\(videoId)?playsinline=1"
        guard let url = URL(string: embedURLString) else {
            print("Invalid YouTube URL")
            return
        }
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}

struct HomeView: View {
    @ObservedObject var auth: AuthViewModel
    @ObservedObject var youtubeService = YouTubeVideoService()
    @State private var navigate = false

    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 0xDE / 255.0, green: 0xC3 / 255.0, blue: 0x8E / 255.0)
                    .ignoresSafeArea()

                VStack {
                    Image("SpotLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 110)
                        .padding(.top, 10)

                    ScrollView {
                        if youtubeService.videos.isEmpty {
                            Text("Loading videos...")
                                .foregroundColor(.white)
                                .padding()
                        } else {
                            VStack(spacing: 16) {
                                ForEach(Array(youtubeService.videos.enumerated()), id: \.element.id) { index, video in
                                    VideoCardView(video: video, isFeatured: index == 0)
                                }

                            }
                            .padding()
                        }
                    }


                    Spacer()

                    NavigationLink(destination: destinationView(), isActive: $navigate) {
                        EmptyView()
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing:
                Button(action: {
                    navigate = true
                }) {
                    Image(systemName: auth.user != nil ? "person.crop.circle" : "person.crop.circle.fill.badge.plus")
                        .font(.title2)
                }
            )
            .onAppear {
                auth.user = Auth.auth().currentUser
                youtubeService.fetchVideos()
            }
        }
    }

    @ViewBuilder
    private func destinationView() -> some View {
        if auth.user != nil {
            AccountView(auth: auth)
        } else {
            AuthView(auth: auth)
        }
    }
}

struct VideoCardView: View {
    let video: YouTubeVideo
    let isFeatured: Bool // ✅ Add this
    @State private var showVideo = false
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .topTrailing) {
                if let url = URL(string: video.thumbnailURL),
                   let data = try? Data(contentsOf: url),
                   let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
                        .frame(height: 200)
                        .clipped()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                } else {
                    Color.gray
                        .frame(height: 200)
                        .cornerRadius(10)
                }

                Text("FEATURED")
                    .font(.caption)
                    .bold()
                    .foregroundColor(.white)
                    .padding(8)
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(5)
                    .padding([.top, .trailing], 10)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text(video.title)
                    .font(.headline)
                    .foregroundColor(.black)

                HStack {
                    Button(action: {
                        showVideo = true
                    }) {
                        Image(systemName: "play.circle.fill")
                            .font(.title)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .sheet(isPresented: $showVideo) {
                        YoutubePlayerView(videoId: video.id)
                            .frame(height: 300)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            .padding()
                    }

                    Spacer()

                    Button(action: {
                        if let url = URL(string: "https://www.youtube.com/watch?v=\(video.id)") {
                            let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
                            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                               let rootVC = windowScene.windows.first?.rootViewController {
                                rootVC.present(activityVC, animated: true, completion: nil)
                            }
                        }
                    }) {
                        Image(systemName: "square.and.arrow.up")
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding()
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 5)
        .padding()
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(auth: AuthViewModel())
    }
}
 
