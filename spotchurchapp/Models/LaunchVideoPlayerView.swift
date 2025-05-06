//
//  UIViewRepresentable.swift
//  spotchurchapp
//
//  Created by Eyoab Asrat on 5/5/25.
//

import SwiftUI
import AVKit

struct LaunchVideoPlayerView: UIViewRepresentable {
    let videoName: String
    let videoExtension: String
    var onVideoFinished: () -> Void

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)

        guard let path = Bundle.main.path(forResource: videoName, ofType: videoExtension) else {
            print(" Video not found in bundle")
            return view
        }

        let player = AVPlayer(url: URL(fileURLWithPath: path))
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.frame = UIScreen.main.bounds
        playerLayer.setAffineTransform(CGAffineTransform(scaleX:  1.0, y: 1.0))

        view.layer.addSublayer(playerLayer)
        player.play()

        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem,
            queue: .main
        ) { _ in
            onVideoFinished()
        }

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}
