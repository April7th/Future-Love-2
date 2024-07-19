//
//  CellSwap1.swift
//  FutureLove
//
//  Created by Phạm Quý Thịnh on 22/01/2024.
//

import UIKit
import AVKit
import AVFoundation
class CellSwap1: UICollectionViewCell {

    @IBOutlet var videoPlayerView: UIView!
    var player: AVPlayer?

    func configureCell(with videoURL: URL?) {
        // Xóa player cũ và các layer liên quan
        player?.pause()
        player = nil
        videoPlayerView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }

        if let videoURL = videoURL {
            player = AVPlayer(url: videoURL)
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.videoGravity = .resizeAspectFill
            playerLayer.frame = videoPlayerView.bounds
            videoPlayerView.layer.addSublayer(playerLayer)

            NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)

            player?.play()
        }
    }



    // Phương thức được gọi khi AVPlayer kết thúc việc phát video
    @objc func playerDidFinishPlaying(note: NSNotification) {
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
