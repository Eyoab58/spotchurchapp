//
//  LaunchVideoView.swift
//  spotchurchapp
//
//  Created by Eyoab Asrat on 4/28/25.
//
import SwiftUI
import AVKit

struct LaunchVideoView: View {
    @Binding var isVideoFinished: Bool  // Bind to control when to move past launch screen
    
    var body: some View {
        if let videoURL = Bundle.main.url(forResource: "launchAnimation", withExtension: "mp4") {
            VideoPlayer(player: AVPlayer(url: videoURL))
                .onAppear {
                    let player = AVPlayer(url: videoURL)
                    player.play()
                    
                    NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main) { _ in
                        isVideoFinished = true
                    }
                }
                .ignoresSafeArea()
        } else {
            Text("Video not found!")
                .foregroundColor(.red)
                .onAppear {
                    print(" launchAnimation.mp4 not found in bundle!")
                }
        }
    }
}
