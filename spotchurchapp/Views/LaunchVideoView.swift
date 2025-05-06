//
//  LaunchVideoView.swift
//  spotchurchapp
//
//  Created by Eyoab Asrat on 4/28/25.
//

import SwiftUI
import AVKit

struct LaunchVideoView: View {
    @Binding var isVideoFinished: Bool  // Used to switch to main content

    var body: some View {
        LaunchVideoPlayerView(videoName: "launchAnimation", videoExtension: "mp4") {
            isVideoFinished = true
        }
        .ignoresSafeArea()
    }
}
