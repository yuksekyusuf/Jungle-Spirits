//
//  TestView.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 15.11.2023.
//

import SwiftUI
import AVFoundation

class VideoPlayerViewController: UIViewController {
    var player: AVPlayer?
    var onVideoEnd: () -> Void = {}

    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Assuming the video is in the app bundle
        if let filePath = Bundle.main.path(forResource: "story", ofType: ".mp4") {
            let videoURL = URL(fileURLWithPath: filePath)
            player = AVPlayer(url: videoURL)
            
            
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = self.view.bounds
            playerLayer.videoGravity = .resizeAspectFill
            view.layer.addSublayer(playerLayer)
            
            // Add observer to know when the video ends
            NotificationCenter.default.addObserver(self, selector: #selector(videoDidEnd), name: .AVPlayerItemDidPlayToEndTime, object: nil)
            
            player?.play()
        }
    }

    @objc func videoDidEnd(notification: NSNotification) {
        // Dismiss the view when the video ends
//        self.dismiss(animated: true, completion: nil)
        onVideoEnd()
    }
}

struct VideoPlayerView: UIViewControllerRepresentable {
    
    var onVideoEnd: () -> Void
    func makeUIViewController(context: Context) -> VideoPlayerViewController {
        let controller = VideoPlayerViewController()
        controller.onVideoEnd = onVideoEnd
        return controller
    }

    func updateUIViewController(_ uiViewController: VideoPlayerViewController, context: Context) {
        // Update the view controller if needed
    }
}

