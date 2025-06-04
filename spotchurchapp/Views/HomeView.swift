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
        let configuration = makeViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.scrollView.isScrollEnabled = false
        webView.backgroundColor = .clear
        webView.isOpaque = false
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let embedURLString = "https://www.youtube.com/embed/\(videoId)?playsinline=1"
        guard let url = URL(string: embedURLString) else {
            print(" Invalid YouTube URL")
            return
        }
        uiView.load(URLRequest(url: url))
    }

    private func makeViewConfiguration() -> WKWebViewConfiguration {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []

        //  Optional: Inject custom JavaScript
        let dropSharedWorkersScript = WKUserScript(
            source: "delete window.SharedWorker;",
            injectionTime: .atDocumentStart,
            forMainFrameOnly: false
        )
        configuration.userContentController.addUserScript(dropSharedWorkersScript)

        return configuration
    }
}

struct HomeView: View {
    @State private var selectedVideo: YouTubeVideo? = nil
    @ObservedObject var auth: AuthViewModel
    @ObservedObject var youtubeService = YouTubeVideoService()
    @State private var navigate = false

    var body: some View {
        NavigationView {
            ZStack {
                Image("chatGPT")
                    .resizable()
                    .scaledToFill()
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
                                    VideoCardView(video: video, isFeatured: index == 0) { selected in
                                        selectedVideo = selected
                                    }

                                }
                                
                            }
                            .padding()
                        }
                    }
                        
                    .onAppear {
                        Task {
                            print("Calling fetchVideos()")
                            auth.user = Auth.auth().currentUser
                            await youtubeService.fetchVideos()
                        }
                    }



                    Spacer()
                    NavigationLink(destination: destinationView(), isActive: $navigate) {
                        EmptyView()
                    }
                    
                }
            }
            .sheet(item: $selectedVideo) { video in
                YoutubePlayerView(videoId: video.id)
                    .frame(height: 300)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding()
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
    let isFeatured: Bool
    let onPlay: (YouTubeVideo) -> Void


    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .topTrailing) {
                RemoteImageView(urlString: video.thumbnailURL)
                
                if isFeatured {
                    Text("FEATURED")
                        .font(.caption)
                        .bold()
                        .foregroundColor(.white)
                        .padding(6)
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(5)
                        .padding([.top, .trailing], 8)
                }
            }
            
            Text(video.title)
                .font(.headline)
                .foregroundColor(.primary)
                .padding(.horizontal, 8)
        
            
            
            HStack {
                Button(action: {
                    print("Play button tapped")
                    onPlay(video)
                }) {
                    Image(systemName: "play.circle.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
                .buttonStyle(PlainButtonStyle())



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
                        .foregroundColor(.gray)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 8)
        }
        .frame(maxWidth: 350)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 4)
        .padding(.horizontal)
        .padding(.top, 8)
    }
}



struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(auth: AuthViewModel())
    }
}
 
