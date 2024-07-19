//
//  CellSwap3.swift
//  FutureLove
//
//  Created by Phạm Quý Thịnh on 24/01/2024.
//

import UIKit
import AVKit
import AVFoundation
class CellSwap3: UICollectionViewCell {

    @IBOutlet var videoView: UIView!
    var player: AVPlayer?
    var videoURL: URL? {
        didSet {
            configureCellVideo(with: videoURL)
        }
    }
    func configureCellVideo(with videoURL: URL?) {
        // Xóa player cũ và các layer liên quan
        player?.pause()
        player = nil
        videoView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }

        if let videoURL = videoURL {
            player = AVPlayer(url: videoURL)
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.videoGravity = .resizeAspectFill
            playerLayer.frame = videoView.bounds
            videoView.layer.addSublayer(playerLayer)

            NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlayingvVideo), name: .AVPlayerItemDidPlayToEndTime, object: nil)

            player?.play()
        }
    }



    // Phương thức được gọi khi AVPlayer kết thúc việc phát video
    @objc func playerDidFinishPlayingvVideo(note: NSNotification) {
        player?.seek(to: CMTime.zero)
        player?.play()
    }


    func play() {
        player?.play()
    }

    func pause() {
        player?.pause()
    }

}

