//
//  VideoPlayer.swift
//  Vinder
//
//  Created by Dayson Dong on 2019-06-21.
//  Copyright © 2019 Frank Chen. All rights reserved.
//

import Foundation
import AVKit

class VideoPlayer {
    
    var playerLayer: AVPlayerLayer?
    var player: AVPlayer?
    
    func playVideo(atUrl videoUrl: URL, on view: UIView) {

        player = AVPlayer(url: videoUrl)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.videoGravity = .resizeAspectFill
        if let playerLayer = self.playerLayer {
            view.layer.insertSublayer(playerLayer, at: 1)
            playerLayer.frame = view.layer.frame
        }
        player?.play()
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd(notification:)), name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
    }
    
    @objc func playerItemDidReachEnd(notification: Notification) {
        if let playerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: CMTime.zero, completionHandler: nil)
            player?.play()
        }
    }
    
    
    
}
