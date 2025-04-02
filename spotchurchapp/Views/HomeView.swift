//
//  HomeView.swift
//  spotchurchapp
//
//  Created by Eyoab Asrat on 3/17/25.
//

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

                    FeaturedVideoCard()
                    Spacer()

                    // 🔁 Dynamic NavigationLink
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
                // Refresh auth state on view appear
                auth.user = Auth.auth().currentUser
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

// FEATURED VIDEO CARD COMPONENT
struct FeaturedVideoCard: View {
    @State private var showVideo = false

    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .topTrailing) {
                Image("RTD") // Replace with your asset name
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 10))

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
                Text("Enemies to Our Christian Walk: Intrigues of the Devil")
                    .font(.headline)
                    .foregroundColor(.black)

                HStack {
                    // Button to show video player
                    Button(action: {
                        showVideo = true // ✅ Open modal
                    }) {
                        Image(systemName: "play.circle.fill")
                            .font(.title)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .sheet(isPresented: $showVideo) { // ✅ Show video in a modal
                        YoutubePlayerView(videoId: "n2NZSB7PFAs")
                            .frame(height: 300)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            .padding()
                    }

                    Spacer()

                    Button(action: {
                        let url = URL(string: "https://www.youtube.com/watch?v=n2NZSB7PFAs")!
                        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
                        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                           let rootVC = windowScene.windows.first?.rootViewController {
                            rootVC.present(activityVC, animated: true, completion: nil)
                        }
                    }) {
                        Image(systemName: "square.and.arrow.up")
                    }
                    .buttonStyle(PlainButtonStyle())

                    Text("5d")
                        .font(.caption)
                        .foregroundColor(.gray)
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

// PREVIEWS
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(auth: AuthViewModel())
    }
}
